//
//  VisionPlugin.swift
//  flutter_document_scanner_ios
//
//  Created by Christian Betancourt Barajas on 6/11/23.
//

import Flutter
import Foundation
import Vision
import UIKit


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
        
        guard let ciImage = CIImage(image: image)?.oriented(.rightMirrored) else {
            result(FlutterError(code: "ADJUSTING_PERSPECTIVE", message: "Invalid CIImage", details: nil))
            return
        }
        
        
        guard points.count == 4,
              let topLeft = CGPoint(dictionary: points[0]),
              let topRight = CGPoint(dictionary: points[1]),
              let bottomRight = CGPoint(dictionary: points[2]),
              let bottomLeft = CGPoint(dictionary: points[3]) else {
            result(FlutterError(code: "ADJUSTING_PERSPECTIVE", message: "Invalid Points", details: nil))
            return
        }
        
        guard let perspectiveCorrection = CIFilter(name: "CIPerspectiveCorrection") else {
            result(FlutterError(
                code: "ADJUSTING_PERSPECTIVE",
                message: "Could not create perspective correction filter",
                details: nil
            ))
            return
        }
        
        perspectiveCorrection.setValue(ciImage, forKey: kCIInputImageKey)
        perspectiveCorrection.setValue(CIVector(cgPoint: topLeft), forKey: "inputTopLeft")
        perspectiveCorrection.setValue(CIVector(cgPoint: topRight), forKey: "inputTopRight")
        perspectiveCorrection.setValue(CIVector(cgPoint: bottomLeft), forKey: "inputBottomLeft")
        perspectiveCorrection.setValue(CIVector(cgPoint: bottomRight), forKey: "inputBottomRight")
        
        
        guard let outputImage = perspectiveCorrection.outputImage else {
            result(FlutterError(
                code: "ADJUSTING_PERSPECTIVE",
                message: "Could not get output image from filter",
                details: nil
            ))
            return
        }
        
        
        let context = CIContext(options: nil)
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
        
        guard let ciImage = CIImage(image: image) else {
            result(FlutterError(code: "ADJUSTING_PERSPECTIVE", message: "Invalid CIImage", details: nil))
            return
        }
        
        switch filter {
            // Gray
        case 2:
            guard let grayFilter = CIFilter(name: "CIColorControls") else {
                result(FlutterError(code: "APPLY_FILTER", message: "Could not make filter", details: nil))
                break
            }
            
            grayFilter.setValue(ciImage, forKey: kCIInputImageKey)
            grayFilter.setValue(0, forKey: kCIInputSaturationKey)
            
            guard let output = grayFilter.outputImage else {
                result(FlutterError(code: "APPLY_FILTER", message: "Could not apply filter", details: nil))
                break
            }
            
            let context = CIContext(options: nil)
            guard let cgimg = context.createCGImage(output, from: output.extent) else {
                result(FlutterError(code: "APPLY_FILTER", message: "Could not create CGImage", details: nil))
                break
            }
            
            let uiImage = UIImage(cgImage: cgimg)
            guard let imageData = uiImage.jpegData(compressionQuality: 1) else {
                result(FlutterError(
                    code: "APPLY_FILTER",
                    message: "Could not get JPEG data from UIImage",
                    details: nil
                ))
                return
            }
            
            result(FlutterStandardTypedData(bytes: imageData))
            break
            
            // Eco
        case 3:
            guard let colorMonochromeFilter = CIFilter(name: "CIColorMonochrome") else {
                result(FlutterError(
                    code: "APPLY_FILTER",
                    message: "Could not make color mono chrome filter",
                    details: nil
                ))
                break
            }
            
            colorMonochromeFilter.setValue(ciImage, forKey: kCIInputImageKey)
            colorMonochromeFilter.setValue(CIColor(color: UIColor.white), forKey: "inputColor")
            colorMonochromeFilter.setValue(1, forKey: "inputIntensity")
            
            guard let monochromeImage = colorMonochromeFilter.outputImage else {
                result(FlutterError(
                    code: "APPLY_FILTER",
                    message: "Could not apply color mono chrome filter",
                    details: nil
                ))
                break
            }
            
            
            guard let colorControlsFilter = CIFilter(name: "CIColorControls") else {
                result(FlutterError(code: "APPLY_FILTER", message: "Could not make color control filter", details: nil))
                break
            }
            
            colorControlsFilter.setValue(monochromeImage, forKey: kCIInputImageKey)
            colorControlsFilter.setValue(0, forKey: "inputBrightness")
            colorControlsFilter.setValue(1, forKey: "inputContrast")
            
            guard let colorControlsImage = colorControlsFilter.outputImage else {
                result(FlutterError(code: "APPLY_FILTER", message: "Could not apply color control filter", details: nil))
                break
            }
            
            
            guard let unsharpMaskFilter = CIFilter(name: "CIUnsharpMask") else {
                result(FlutterError(code: "APPLY_FILTER", message: "Could not make unsharp filter", details: nil))
                break
            }
            
            unsharpMaskFilter.setValue(colorControlsImage, forKey: kCIInputImageKey)
            unsharpMaskFilter.setValue(1, forKey: kCIInputRadiusKey)
            unsharpMaskFilter.setValue(2, forKey: kCIInputIntensityKey)
            
            guard let unsharpMaskImage = unsharpMaskFilter.outputImage else {
                result(FlutterError(code: "APPLY_FILTER", message: "Could not apply unsharp filter", details: nil))
                break
            }
            
            
            let context = CIContext(options: nil)
            guard let cgimg = context.createCGImage(unsharpMaskImage, from: unsharpMaskImage.extent) else {
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
}

