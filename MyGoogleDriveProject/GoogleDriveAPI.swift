//
//  GoogleDriveAPI.swift
//  MyGoogleDriveProject
//
//  Created by Nguyen Uy on 17/2/19.
//  Copyright © 2019 Nguyen Uy. All rights reserved.
//

import Foundation
import GoogleAPIClientForREST

enum GDriveError: Error {
    case NoDataAtPath
}


class GoogleDriveAPI {
    private let service: GTLRDriveService
    
    init(service: GTLRDriveService) {
        self.service = service
    }
    
    public func search(_ name: String, onCompleted: @escaping (GTLRDrive_File?, Error?) -> ()) {
        let query = GTLRDriveQuery_FilesList.query()
        query.pageSize = 1
        query.q = "name contains '\(name)'"
        self.service.executeQuery(query) { (ticket, results, error) in
            onCompleted((results as? GTLRDrive_FileList)?.files?.first, error)
        }
    }
    
    public func listFiles(_ folderID: String, onCompleted: @escaping (GTLRDrive_FileList?, Error?) -> ()) {
        let query = GTLRDriveQuery_FilesList.query()
        query.pageSize = 100
        query.q = "'\(folderID)' in parents and mimeType != 'application/vnd.google-apps.folder'"
        self.service.executeQuery(query) { (ticket, result, error) in
            onCompleted(result as? GTLRDrive_FileList, error)
        }
    }
    
    public func download(_ fileItem: GTLRDrive_File, onCompleted: @escaping (Data?, Error?) -> ()) {
        guard let fileID = fileItem.identifier else {
            return onCompleted(nil, nil)
        }
        
        self.service.executeQuery(GTLRDriveQuery_FilesGet.queryForMedia(withFileId: fileID)) { (ticket, file, error) in
            guard let data = (file as? GTLRDataObject)?.data else {
                return onCompleted(nil, nil)
            }
            print(data)
            onCompleted(data, nil)
        }
    }
    
   public func uploadFile(_ folderName: String, filePath: String, MIMEType: String, onCompleted: ((String?, Error?) -> ())?) {
        
        search(folderName) { (folderID, error) in
            
            if let ID = folderID?.identifier {
                self.upload(ID, path: filePath, MIMEType: MIMEType, onCompleted: onCompleted)
            } else {
                self.createFolder(folderName, onCompleted: { (folderID, error) in
                    guard let ID = folderID else {
                        onCompleted?(nil, error)
                        return
                    }
                    self.upload(ID, path: filePath, MIMEType: MIMEType, onCompleted: onCompleted)
                })
            }
        }
    }
       
       private func upload(_ parentID: String, path: String, MIMEType: String, onCompleted: ((String?, Error?) -> ())?) {
           
           guard let data = FileManager.default.contents(atPath: path) else {
               onCompleted?(nil, GDriveError.NoDataAtPath)
               return
           }
           
           let file = GTLRDrive_File()
           file.name = path.components(separatedBy: "/").last
           file.parents = [parentID]
           
           let uploadParams = GTLRUploadParameters.init(data: data, mimeType: MIMEType)
           uploadParams.shouldUploadWithSingleRequest = true
           
           let query = GTLRDriveQuery_FilesCreate.query(withObject: file, uploadParameters: uploadParams)
           query.fields = "id"
           
           self.service.executeQuery(query, completionHandler: { (ticket, file, error) in
               onCompleted?((file as? GTLRDrive_File)?.identifier, error)
           })
       }
      
public func createFolder(_ name: String, onCompleted: @escaping (String?, Error?) -> ()) {
    let file = GTLRDrive_File()
    file.name = name
    file.mimeType = "application/vnd.google-apps.folder"
    
    let query = GTLRDriveQuery_FilesCreate.query(withObject: file, uploadParameters: nil)
    query.fields = "id"
    
    service.executeQuery(query) { (ticket, folder, error) in
        onCompleted((folder as? GTLRDrive_File)?.identifier, error)
    }
}
    public func delete(_ fileItem: GTLRDrive_File, onCompleted: @escaping ((Error?) -> ())) {
        guard let fileID = fileItem.identifier else {
            return onCompleted(nil)
        }
        
        self.service.executeQuery(GTLRDriveQuery_FilesDelete.query(withFileId: fileID)) { (ticket, nilFile, error) in
            onCompleted(error)
        }
    }
}
