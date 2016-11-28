//
//  WordList.swift
//  SampleSearchAPI
//
//  Created by YUGWANGYONG on 28/11/2016.
//  Copyright © 2016 yong. All rights reserved.
//

import Foundation

class WordList
{
    let strKey = "list" // key
    let list:[String] // value
    
    // 파일 경로를 받아서 인스턴스를 생성.
    init?(path:String)
    {
        // NSDictionary 를 사용하여 plist 파일을 읽어들인다.
        let listDic = NSDictionary(contentsOfFile:path)
        
        if listDic == nil
        {
            list = []
            return nil
        }
        
        // objectForKey 는 strKey 에 해당하는 인스턴스를 반환한다.
        // list에 대한 배열을 가져와서 list에 할당한다. 
        // as 는 가져온 인스턴스를 문자열의 배열로 변환하는 명령이다.
        // objectForKey 는 해당 키에 대한 값이 어떤 타입일 지 모르기 때문에 AnyObject라는 타입으로 반환한다.
        list = listDic!.objectForKey(strKey) as! [String]
    }
    
    func each(fn:(String) -> ())
    {
        for word in list
        {
            fn(word)
        }
    }
}