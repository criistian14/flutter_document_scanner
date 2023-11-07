//
//  VisionPlugin.swift
//  flutter_document_scanner_ios
//
//  Created by Christian Betancourt Barajas on 6/11/23.
//

import Flutter
import Foundation
import Vision


class VisionPlugin {
    func findContourPhoto(result: @escaping FlutterResult, byteData: FlutterStandardTypedData, minContourArea: Double) {
        guard let image = UIImage(data: byteData.data) else {
            result(FlutterError(code: "FIND_CONTOUR_PHOTO", message: "Invalid ByteData", details: nil))
            return
        }
        
        guard let cgImage = image.cgImage else {
            result(FlutterError(code: "FIND_CONTOUR_PHOTO", message: "Invalid CGImage", details: nil))
            return
        }
        
        let request = VNDetectRectanglesRequest { request, error in
            DispatchQueue.main.async {
                guard let results = request.results as? [VNRectangleObservation], let rectangle = results.first else {
                    result(nil)
                    return
                }
                
                let topLeft = self.convertToPointOfInterest(from: rectangle.topLeft, imageSize: image.size)
                let topRight = self.convertToPointOfInterest(from: rectangle.topRight, imageSize: image.size)
                let bottomLeft = self.convertToPointOfInterest(from: rectangle.bottomLeft, imageSize: image.size)
                let bottomRight = self.convertToPointOfInterest(from: rectangle.bottomRight, imageSize: image.size)
                
                
                let resultEnd = [
                    "height": NSNumber(value: Int(image.size.height)),
                    "width": NSNumber(value: Int(image.size.width)),
                    "points": [
                        [
                            "x": NSNumber(value: topLeft.x),
                            "y": NSNumber(value: topLeft.y),
                        ],
                        [
                            "x": NSNumber(value: topRight.x),
                            "y": NSNumber(value: topRight.y),
                        ],
                        [
                            "x": NSNumber(value: bottomRight.x),
                            "y": NSNumber(value: bottomRight.y),
                        ],
                        [
                            "x": NSNumber(value: bottomLeft.x),
                            "y": NSNumber(value: bottomLeft.y),
                        ],
                    ],
                    "image": nil,
                ]
                
                result (resultEnd)
            }
        }
        
        // TODO: add this config in flutter
        request.minimumConfidence = 0.5
        request.maximumObservations = 1 // Solo el contorno más grande
        request.quadratureTolerance = 25.0
        
        let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])
        DispatchQueue.global(qos: .userInitiated).async {
            do {
                try handler.perform([request])
            } catch {
                DispatchQueue.main.async {
                    result(nil)
                }
            }
        }
    }
    
    private func convertToPointOfInterest(from point: CGPoint, imageSize: CGSize) -> CGPoint {
        let x = point.y * imageSize.width
        let y = point.x * imageSize.height
        
        return CGPoint(x: x, y: y)
    }
    
    func adjustingPerspective(
        result: @escaping FlutterResult,
        byteData: FlutterStandardTypedData,
        points: Array<Dictionary<String, Double>>
    ) {
        guard let image = UIImage(data: byteData.data) else {
            result(FlutterError(code: "ADJUSTING_PERSPECTIVE", message: "Invalid ByteData", details: nil))
            return
        }
        
        guard let ciImage = CIImage(image: image) else {
            result(FlutterError(code: "ADJUSTING_PERSPECTIVE", message: "Invalid CIImage", details: nil))
            return
        }
        
        guard points.count == 4,
              let topLeft = CGPoint(dictionary: points[0]),
              let topRight = CGPoint(dictionary: points[1]),
              let bottomLeft = CGPoint(dictionary: points[3]),
              let bottomRight = CGPoint(dictionary: points[2]) else {
            result(FlutterError(code: "ADJUSTING_PERSPECTIVE", message: "Invalid Points", details: nil))
            return
        }
        
        guard let perspectiveCorrection = CIFilter(name: "CIPerspectiveCorrection") else {
            result(FlutterError(code: "ADJUSTING_PERSPECTIVE", message: "Could not create perspective correction filter", details: nil))
            return
        }
        
        let width = Int(image.size.width)
        let height = Int(image.size.height)
        
        perspectiveCorrection.setValue(ciImage, forKey: "inputImage")
        perspectiveCorrection.setValue(CIVector(cgPoint: VNImagePointForNormalizedPoint(topLeft, width, height)), forKey: "inputTopLeft")
        perspectiveCorrection.setValue(CIVector(cgPoint: VNImagePointForNormalizedPoint(topRight, width, height)), forKey: "inputTopRight")
        perspectiveCorrection.setValue(CIVector(cgPoint: VNImagePointForNormalizedPoint(bottomLeft, width, height)), forKey: "inputBottomLeft")
        perspectiveCorrection.setValue(CIVector(cgPoint: VNImagePointForNormalizedPoint(bottomRight, width, height)), forKey: "inputBottomRight")
        
        
        guard let outputImage = perspectiveCorrection.outputImage else {
            result(FlutterError(code: "ADJUSTING_PERSPECTIVE", message: "Could not get output image from filter", details: nil))
            return
        }
        
        
        let context = CIContext(options: [CIContextOption.workingColorSpace: NSNull()])
        guard let cgImage = context.createCGImage(outputImage, from: outputImage.extent) else {
            result(FlutterError(code: "ADJUSTING_PERSPECTIVE", message: "Could not create CGImage from CIImage", details: nil))
            return
        }
        
        let uiImage = UIImage(cgImage: cgImage)
        guard let imageData = uiImage.jpegData(compressionQuality: 1) else {
            result(FlutterError(code: "ADJUSTING_PERSPECTIVE", message: "Could not get JPEG data from UIImage", details: nil))
            return
        }
        
        result(FlutterStandardTypedData(bytes: imageData))
    }
    
    func applyFilter(
        result: @escaping FlutterResult,
        byteData: FlutterStandardTypedData,
        filter: Int
    ) {
        guard let image = UIImage(data: byteData.data) else {
            result(FlutterError(code: "APPLY_FILTER", message: "Invalid ByteData", details: nil))
            return
        }
        
        switch filter {
            // Gray
        case 2:
            guard let currentFilter = CIFilter(name: "CIColorControls") else {
                result(FlutterError(code: "APPLY_FILTER", message: "Could not make filter", details: nil))
                break
            }
            
            let beginImage = CIImage(image: image)
            currentFilter.setValue(beginImage, forKey: kCIInputImageKey)
            currentFilter.setValue(0, forKey: kCIInputSaturationKey)
            
            guard let output = currentFilter.outputImage else {
                result(FlutterError(code: "APPLY_FILTER", message: "Could not apply filter", details: nil))
                break
            }
            
            let context = CIContext(options: [CIContextOption.workingColorSpace: NSNull()])
            guard let cgimg = context.createCGImage(output, from: output.extent) else {
                result(FlutterError(code: "APPLY_FILTER", message: "Could not create CGImage", details: nil))
                break
            }
            
            let uiImage = UIImage(cgImage: cgimg)
            guard let imageData = uiImage.jpegData(compressionQuality: 1) else {
                result(FlutterError(code: "APPLY_FILTER", message: "Could not get JPEG data from UIImage", details: nil))
                return
            }
            
            result(FlutterStandardTypedData(bytes: imageData))
            break
            
            // Eco
        case 3:
            guard let currentFilter = CIFilter(name: "CIUnsharpMask") else {
                result(FlutterError(code: "APPLY_FILTER", message: "Could not make filter", details: nil))
                break
            }
            
            let beginImage = CIImage(image: image)
            currentFilter.setValue(beginImage, forKey: kCIInputImageKey)
            currentFilter.setValue(2.5, forKey: kCIInputRadiusKey)
            currentFilter.setValue(0.5, forKey: kCIInputIntensityKey)
            
            guard let output = currentFilter.outputImage else {
                result(FlutterError(code: "APPLY_FILTER", message: "Could not apply filter", details: nil))
                break
            }
            
            let context = CIContext(options: [CIContextOption.workingColorSpace: NSNull()])
            guard let cgimg = context.createCGImage(output, from: output.extent) else {
                result(FlutterError(code: "APPLY_FILTER", message: "Could not create CGImage", details: nil))
                break
            }
            
            let uiImage = UIImage(cgImage: cgimg)
            guard let imageData = uiImage.jpegData(compressionQuality: 1) else {
                result(FlutterError(code: "APPLY_FILTER", message: "Could not get JPEG data from UIImage", details: nil))
                return
            }
            
            result(FlutterStandardTypedData(bytes: imageData))
            break
            
        default:
            result(byteData)
        }
    }
}

extension CGPoint {
    init?(dictionary: [String: Double]) {
        guard let x = dictionary["x"], let y = dictionary["y"] else {
            return nil
        }
        self.init(x: x, y: y)
    }
    
    func scaled(to size: CGSize) -> CGPoint {
        return CGPoint(x: self.x * size.width, y: self.y * size.height)
    }
}

