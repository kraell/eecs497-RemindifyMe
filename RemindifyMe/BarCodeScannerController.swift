//
//  BarCodeScannerController.swift
//  RemindifyMe
//
//  Created by Mohamed Mohamed on 3/16/20.
//  Copyright © 2020 Toasted Peanuts. All rights reserved.
//

import UIKit
import AVFoundation

class BarCodeScannerController: UIViewController {
    var item: Item?
    @IBOutlet weak var messageLabel: UILabel!
    
    @IBOutlet weak var topbarView: UIView!
    
    var captureSession = AVCaptureSession()
        
        var videoPreviewLayer: AVCaptureVideoPreviewLayer?
        var qrCodeFrameView: UIView?

        private let supportedCodeTypes = [AVMetadataObject.ObjectType.upce,
                                          AVMetadataObject.ObjectType.code39,
                                          AVMetadataObject.ObjectType.code39Mod43,
                                          AVMetadataObject.ObjectType.code93,
                                          AVMetadataObject.ObjectType.code128,
                                          AVMetadataObject.ObjectType.ean8,
                                          AVMetadataObject.ObjectType.ean13,
                                          AVMetadataObject.ObjectType.aztec,
                                          AVMetadataObject.ObjectType.pdf417,
                                          AVMetadataObject.ObjectType.itf14,
                                          AVMetadataObject.ObjectType.dataMatrix,
                                          AVMetadataObject.ObjectType.interleaved2of5,
                                          AVMetadataObject.ObjectType.qr]
       
        override func viewDidLoad() {
            super.viewDidLoad()

            // Get the back-facing camera for capturing videos
            guard let captureDevice = AVCaptureDevice.default(for: AVMediaType.video) else {
                print("Failed to get the camera device")
                return
            }
            
            do {
                // Get an instance of the AVCaptureDeviceInput class using the previous device object.
                let input = try AVCaptureDeviceInput(device: captureDevice)
                
                // Set the input device on the capture session.
                captureSession.addInput(input)
                
                // Initialize a AVCaptureMetadataOutput object and set it as the output device to the capture session.
                let captureMetadataOutput = AVCaptureMetadataOutput()
                captureSession.addOutput(captureMetadataOutput)
                
                // Set delegate and use the default dispatch queue to execute the call back
                captureMetadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
                captureMetadataOutput.metadataObjectTypes = supportedCodeTypes
    //            captureMetadataOutput.metadataObjectTypes = [AVMetadataObject.ObjectType.qr]
                
            } catch {
                // If any error occurs, simply print it out and don't continue any more.
                print(error)
                return
            }
            
            // Initialize the video preview layer and add it as a sublayer to the viewPreview view's layer.
            videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
            videoPreviewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
            videoPreviewLayer?.frame = view.layer.bounds
            view.layer.addSublayer(videoPreviewLayer!)
            
            // Start video capture.
            captureSession.startRunning()
            
            // Move the message label and top bar to the front
            view.bringSubviewToFront(messageLabel)
            view.bringSubviewToFront(topbarView)
            
            // Initialize QR Code Frame to highlight the QR code
            qrCodeFrameView = UIView()
            
            if let qrCodeFrameView = qrCodeFrameView {
                qrCodeFrameView.layer.borderColor = UIColor.red.cgColor
                qrCodeFrameView.layer.borderWidth = 2
                view.addSubview(qrCodeFrameView)
                view.bringSubviewToFront(qrCodeFrameView)
            }
        }

        override func didReceiveMemoryWarning() {
            super.didReceiveMemoryWarning()
            // Dispose of any resources that can be recreated.
        }
        
        // MARK: - Helper methods
    func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
    
    func downloadItemImage(from url: URL) {
        getData(from: url) { data, response, error in
            guard let data = data, error == nil else { return }
            print(response?.suggestedFilename ?? url.lastPathComponent)
            DispatchQueue.main.async() {
                self.item?.image = UIImage(data: data)!
            }
        }
    }

        func showUPC(decodedURL: String) {
            
            if presentedViewController != nil {
                return
            }
            
            let itemRequest = ItemRequest(upc: decodedURL)
            itemRequest.getItem { [weak self] result in
                switch result {
                case .success(let item):
                    
                    self?.item =
                        Item(name: item.title, expiration_date: "", image: #imageLiteral(resourceName: "clear"))
                    if item.images.count > 0 {
                        let url = URL(string: item.images[0])
                        self!.downloadItemImage(from: url!)
                    }
                case .failure(let error):
                    print(error)
                }
            }
            
            let alertPrompt = UIAlertController(title: "UPC", message: "Do you want to add UPC number \(decodedURL)?", preferredStyle: .actionSheet)
            let confirmAction = UIAlertAction(title: "Add item to list", style: UIAlertAction.Style.default, handler: { _ in
                self.performSegue(withIdentifier: "NewScannedObject", sender: nil)
            })
            
            let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil)
            
            alertPrompt.addAction(confirmAction)
            alertPrompt.addAction(cancelAction)
            
            present(alertPrompt, animated: true, completion: nil)
        }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier == "NewScannedObject" {
            let top = segue.destination as! UINavigationController
            let addEditItemTableViewController = top.topViewController as! AddEditItemTableViewController
            addEditItemTableViewController.item = item
        }
    }
    
      private func updatePreviewLayer(layer: AVCaptureConnection, orientation: AVCaptureVideoOrientation) {
        layer.videoOrientation = orientation
        videoPreviewLayer?.frame = self.view.bounds
      }
      
      override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if let connection =  self.videoPreviewLayer?.connection  {
          let currentDevice: UIDevice = UIDevice.current
          let orientation: UIDeviceOrientation = currentDevice.orientation
          let previewLayerConnection : AVCaptureConnection = connection
          
          if previewLayerConnection.isVideoOrientationSupported {
            switch (orientation) {
            case .portrait:
              updatePreviewLayer(layer: previewLayerConnection, orientation: .portrait)
              break
            case .landscapeRight:
              updatePreviewLayer(layer: previewLayerConnection, orientation: .landscapeLeft)
              break
            case .landscapeLeft:
              updatePreviewLayer(layer: previewLayerConnection, orientation: .landscapeRight)
              break
            case .portraitUpsideDown:
              updatePreviewLayer(layer: previewLayerConnection, orientation: .portraitUpsideDown)
              break
            default:
              updatePreviewLayer(layer: previewLayerConnection, orientation: .portrait)
              break
            }
          }
        }
      }

    }

extension BarCodeScannerController: AVCaptureMetadataOutputObjectsDelegate {
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        // Check if the metadataObjects array is not nil and it contains at least one object.
        if metadataObjects.count == 0 {
            qrCodeFrameView?.frame = CGRect.zero
            messageLabel.text = "No QR code is detected"
            return
        }
        
        // Get the metadata object.
        let metadataObj = metadataObjects[0] as! AVMetadataMachineReadableCodeObject
        
        if supportedCodeTypes.contains(metadataObj.type) {
            // If the found metadata is equal to the QR code metadata (or barcode) then update the status label's text and set the bounds
            let barCodeObject = videoPreviewLayer?.transformedMetadataObject(for: metadataObj)
            qrCodeFrameView?.frame = barCodeObject!.bounds
            
            if metadataObj.stringValue != nil {
                showUPC(decodedURL: metadataObj.stringValue!)
                messageLabel.text = metadataObj.stringValue
            }
        }
    }
    
}

