//
//  FlutterDocumentScanner.swift
//  flutter_document_scanner_ios
//
//  Created by Christian Betancourt Barajas on 28/04/23.
//

import Flutter
import UIKit

enum ErrorsPlugin : Error {
    case stringError(String )
}

public class FlutterDocumentScannerPlugin: NSObject, FlutterPlugin {
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "flutter_document_scanner_ios", binaryMessenger: registrar.messenger())
        let instance = FlutterDocumentScannerPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch (call.method) {
        case "findContourPhoto":
            do {
                guard let arguments = call.arguments as? Dictionary<String, Any>
                        
                else {
                    throw ErrorsPlugin.stringError("Invalid Arguments")
                }
                
                let visionPlugin = VisionPlugin()
                
                visionPlugin.findContourPhoto(
                    result: result,
                    byteData: arguments["byteData"] as! FlutterStandardTypedData,
                    minContourArea: arguments["minContourArea"] as! Double
                )
                
            } catch {
                result(FlutterError(
                    code: "FlutterDocumentScanner-Error",
                    message: "findContourPhoto \(error.localizedDescription)",
                    details: error
                ))
            }
            break;
            
        case "adjustingPerspective":
            do {
                guard let arguments = call.arguments as? Dictionary<String, Any>
                        
                else {
                    throw ErrorsPlugin.stringError("Invalid Arguments")
                }
                
                let visionPlugin = VisionPlugin()
                
                visionPlugin.adjustingPerspective(
                    result: result,
                    byteData: arguments["byteData"] as! FlutterStandardTypedData,
                    points: arguments["points"] as! Array<Dictionary<String, Double>>
                )
                
            } catch {
                result(FlutterError(
                    code: "FlutterDocumentScanner-Error",
                    message: "adjustingPerspective \(error.localizedDescription)",
                    details: error
                ))
            }
            break;
            
        case "applyFilter":
            do {
                guard let arguments = call.arguments as? Dictionary<String, Any>
                        
                else {
                    throw ErrorsPlugin.stringError("Invalid Arguments")
                }
                
                let visionPlugin = VisionPlugin()
                
                visionPlugin.applyFilter(
                    result: result,
                    byteData: arguments["byteData"] as! FlutterStandardTypedData,
                    filter: arguments["filter"] as! Int
                )
                
            } catch {
                result(FlutterError(
                    code: "FlutterDocumentScanner-Error",
                    message: "applyFilter \(error.localizedDescription)",
                    details: error
                ))
            }
            break;
            
        default:
            result(FlutterMethodNotImplemented)
        }
    }
}
