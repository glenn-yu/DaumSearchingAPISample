//
//  main.swift
//  SampleSearchAPI
//
//  Created by YUGWANGYONG on 28/11/2016.
//  Copyright © 2016 yong. All rights reserved.
//

import Foundation

// 명령행 인자를 검사한다.
// Process(명령행) arguments(인자)
if Process.arguments.count < 2
{
    print("Usage: \(Process.arguments[0]) list_file")
    exit(1)
}

print("List file is \(Process.arguments[1])")


// 키워드 리스트 파일을 읽는다.
let wordList = WordList(path:Process.arguments[1])
if wordList == nil
{
    print("File load error")
}

// 각 키워드에 대해서 검색한다.
var word:String
for word in wordList!.list
{
    // OpenAPI 요청을 보낸다.
    let search = Search(keyword:word)
    if search.request() == false
    {
        print("Search error : \(search.keyword)")
        exit(1) // 스위프트 기본 제공 종료 메소드, 0이면 성공, 1이나 기타이면 실패
    }
    
    // 결과를 파싱한다.
    if search.parse() == false
    {
        print("Parse error : \(search.keyword)")
        exit(1)
    }
    
    // 결과를 출력한다.
    print( "\(search.keyword) : total(\(search.totalCount)), page(\(search.pageCount))" )
}