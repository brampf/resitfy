//
//  File.swift
//  
//
//  Created by May on 03.03.20.
//

import Foundation

/// Status codes according to https://www.iana.org/assignments/http-status-codes/http-status-codes.xhtml
public enum HTTPStatus {
    
    //2xx
    case OK
    case Created
    case Accepted
    case NonAuthoritativeInformation
    case NoContent
    case ResetContent
    case PartialContent
    case MultiStatus
    case AlreadyReported
    //4xx
    case BadRequest
    case Unauthorized
    case PaymentRequired
    case Forbidden
    case NotFound
    case MethodNotAllowed
    case NotAcceptable
    case ProxyAuthenticationRequired
    case RequestTimeout
    case Conflict
    case Gone
    case LengthRequired
    case PreconditionFailed
    case PayloadTooLarge
    case URITooLong
    case UnsupportedMediaType
    case RangeNotSatisfiable
    case ExpectationFailed
    //5xx
    case InternalServerError
    case NotImplemented
    case BadGateway
    case ServiceUnavailable
    case GatewayTimeout
    case HTTPVersionNotSupported
    case VariantAlsoNegotiates
    case InsufficientStorage
    case LoopDetected
    case Unassigned
    case NotExtended
    case NetworkAuthenticationRequired
    
    case CODE(Int)
    
    var code : Int {
        switch self {
        case .OK: return 200
        case .Created: return 201
        case .Accepted: return 202
        case .NonAuthoritativeInformation: return 203
        case .NoContent: return 204
        case .ResetContent: return 205
        case .PartialContent: return 206
        case .MultiStatus: return 207
        case .AlreadyReported: return 208
        //4xx
        case .BadRequest: return 400
        case .Unauthorized: return 401
        case .PaymentRequired: return 402
        case .Forbidden: return 403
        case .NotFound: return 404
        case .MethodNotAllowed: return 405
        case .NotAcceptable: return 406
        case .ProxyAuthenticationRequired: return 407
        case .RequestTimeout: return 408
        case .Conflict: return 409
        case .Gone: return 410
        case .LengthRequired: return 411
        case .PreconditionFailed: return 412
        case .PayloadTooLarge: return 413
        case .URITooLong: return 414
        case .UnsupportedMediaType: return 415
        case .RangeNotSatisfiable: return 416
        case .ExpectationFailed: return 417
        //5xx
        case .InternalServerError: return 500
        case .NotImplemented: return 501
        case .BadGateway: return 502
        case .ServiceUnavailable: return 503
        case .GatewayTimeout: return 504
        case .HTTPVersionNotSupported: return 505
        case .VariantAlsoNegotiates: return 506
        case .InsufficientStorage: return 507
        case .LoopDetected: return 508
        case .Unassigned: return 509
        case .NotExtended: return 510
        case .NetworkAuthenticationRequired: return 511
            
        case .CODE(let code): return code
        }
    }
}
