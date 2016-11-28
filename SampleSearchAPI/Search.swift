//
//  Search.swift
//  SampleSearchAPI
//
//  Created by YUGWANGYONG on 28/11/2016.
//  Copyright © 2016 yong. All rights reserved.
//

import Foundation

/*
 OpenAPI 로 검색 결과를 받고, 그 결과를 xml 파싱해서 우리가 필요로 하는 검색 결과수를 저장 프로퍼티에 저장하는 곳.
 */

class Search : NSObject, NSXMLParserDelegate
{
    // OpenAPI 요청을 위한 상수
    let apikey = "API를 추가해주세요."
    let url_format = "http://apis.daum.net/search/web?apikey=%@&q=%@&output=xml"
    let totalCountElement = "totalCount"
    let pageCountElement = "pageCount"
    let keyword:String // 검색할 키워드
    
    // 결과
    var resultData:NSData? // OpenAPI의 결과
    var totalCount:Int = 0
    var pageCount:Int = 0
    
    // 파싱에 필요한 변수
    var parseElement:NSString? = nil
    var parseData:NSMutableString? = nil
    
    // init
    // keyword 를 받아서 인스턴스를 생성한다.
    // 상수를 저장하고 종료한다.
    init(keyword:String)
    {
        self.keyword = keyword
    }
    
    // request
    // OpenAPI 를 호출한다.
    func request() -> Bool
    {
        // 요청을 보내기 위한 NSURL 인스턴스를 생성한다.
        // URL 인코딩 16진수로 된 문자열로 변환. (stringByAddingPercentEncodingWithAllowedCharacters)
        // URLQueryAllowedCharacterSet 은 URL 인코딩에 쓸 캐릭터 셋을 넘겨준다.
        let encodedKeyword = keyword.stringByAddingPercentEncodingWithAllowedCharacters(.URLQueryAllowedCharacterSet())!
        let url = NSURL(string:String(format:url_format, apikey, encodedKeyword))
        if url == nil
        {
            return false
        }
        
        // 요청을 보낸다
        resultData = NSData(contentsOfURL: url!)
        if resultData == nil
        {
            return false
        }
        
        return true
    }
    
    // parse
    // 요청 결과를 파싱하여 검색 결과를 생성한다.
    func parse() -> Bool
    {
        let parser = NSXMLParser(data: self.resultData!)
        
        parseData = NSMutableString()
        parser.delegate = self
        
        return parser.parse()
    }
    
    // MARK: NSXMLParserDelegate
    func parser(parser: NSXMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDic: [String :String])
    {
        parseElement = elementName
        parseData = ""
    }
    
    func parser(parser: NSXMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?)
    {
        switch(parseElement! as String)
        {
            case totalCountElement:
                totalCount = Int(parseData! as String)! // Swift 2.0 -> toInt is unavailable: Use Int() initializer
            break
            
        case pageCountElement:
            pageCount = Int(parseData! as String)! // Swift 2.0 -> toInt is unavailable: Use Int() initializer
            break
            
        default:
            break
        }
        
        parseData = ""
    }
    
    func parser(parser: NSXMLParser, foundCharacters string: String)
    {
        parseData!.appendString(string)
    }
}

