//
//  NFCManager.swift
//  smartag
//
//  Created by Rubén Alonso on 29/12/2020.
//

import Foundation
import CoreNFC

protocol NFCManagerDelegate: class {
    func nfcManager(didInvalidate error: Error)
    func nfcManager(didDetect messages: [NFCTags])
    func nfcManagerDidBecomeActive()
}

class NFCManager: NSObject {

    static let shared = NFCManager()
    private var nfcSession: NFCNDEFReaderSession?
    weak var delegate: NFCManagerDelegate?

    var isReadingAvailable: Bool {
        return NFCNDEFReaderSession.readingAvailable
    }

    func start(message: String? = "") {
        nfcSession = NFCNDEFReaderSession(delegate: self,
                                          queue: nil,
                                          invalidateAfterFirstRead: true)
        nfcSession?.alertMessage = message!
        nfcSession?.begin()
    }

    func stop() {
        DispatchQueue.main.async {
            self.nfcSession?.invalidate()
        }
    }

    private func parse(payload: NFCNDEFPayload) -> NFCTags? {
        guard let typeString = String(data: payload.type, encoding: .utf8) else {
            return nil
        }
        let type = NFCType(rawValue: typeString)
        if payload.typeNameFormat == .nfcWellKnown {
            if type == .uri {
                return NFCTags(text: parseUri(payload: payload), type: type)
            } else if type == .text {
                let text = String(data: payload.payload.advanced(by: 3), encoding: .utf8) ?? ""
                return NFCTags(text: text, type: type)
            } else {
                let text = String(data: payload.payload, encoding: .utf8) ?? ""
                return NFCTags(text: text, type: type)
            }
        } else if payload.typeNameFormat == .media {
            let text = String(data: payload.payload, encoding: .utf8) ?? ""
            return NFCTags(text: text, type: type)
        }
        return nil
    }

    private func parseUri(payload: NFCNDEFPayload) -> String {
        var result = String(data: payload.payload.advanced(by: 1), encoding: .utf8) ?? ""
        let byte = payload.payload.first
        switch byte {
        case 0x01:
            result = "http://www." + result
        case 0x02:
            result = "https://www." + result
        case 0x03:
            result = "http://" + result
        case 0x04:
            result = "https://" + result
        case 0x05:
            result = "tel:" + result
        case 0x06:
            result = "mailto:" + result
        case 0x07:
            result = "ftp://anonymous:anonymous@" + result
        case 0x08:
            result = "ftp://ftp." + result
        case 0x09:
            result = "ftps://" + result
        case 0x0A:
            result = "sftp://" + result
        case 0x0B:
            result = "smb://" + result
        case 0x0C:
            result = "nfs://" + result
        case 0x0D:
            result = "ftp://" + result
        case 0x0E:
            result = "dav://" + result
        case 0x0F:
            result = "news:" + result
        case 0x10:
            result = "telnet://" + result
        case 0x11:
            result = "imap:" + result
        case 0x12:
            result = "rtsp://" + result
        case 0x13:
            result = "urn:" + result
        case 0x14:
            result = "pop:" + result
        case 0x15:
            result = "sip:" + result
        case 0x16:
            result = "sips:" + result
        case 0x17:
            result = "tftp:" + result
        case 0x18:
            result = "btspp://" + result
        case 0x19:
            result = "btl2cap://" + result
        case 0x1A:
            result = "btgoep://" + result
        case 0x1B:
            result = "tcpobex://" + result
        case 0x1C:
            result = "irdaobex://" + result
        case 0x1D:
            result = "file://" + result
        case 0x1E:
            result = "urn:epc:id:" + result
        case 0x1F:
            result = "urn:epc:tag:" + result
        case 0x20:
            result = "urn:epc:pat:" + result
        case 0x21:
            result = "urn:epc:raw:" + result
        case 0x22:
            result = "urn:epc:" + result
        case 0x23:
            result = "urn:nfc:" + result
        default:
            break
        }
        return result
    }
}

extension NFCManager: NFCNDEFReaderSessionDelegate {
    func readerSession(_ session: NFCNDEFReaderSession, didInvalidateWithError error: Error) {
        let error = error as NSError
        if error.code != 200 && error.code != 204 {
            delegate?.nfcManager(didInvalidate: error)
        }
    }

    func readerSession(_ session: NFCNDEFReaderSession, didDetectNDEFs messages: [NFCNDEFMessage]) {
        var result = [NFCTags]()
        for message in messages {
            for payload in message.records {
                if let message = parse(payload: payload) {
                    result.append(message)
                }
            }
        }
        delegate?.nfcManager(didDetect: result)
    }

    func readerSessionDidBecomeActive(_ session: NFCNDEFReaderSession) {
        delegate?.nfcManagerDidBecomeActive()
    }
}
