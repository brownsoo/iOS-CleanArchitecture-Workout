//
//  AppDIContainer.swift
//  App
//
//  Created by hyonsoo on 2023/08/28.
//

import Foundation
import Shared

final class AppDIContainer {
    /// 네트워크 데이터 서비스를 앱 단에서 하나를 유지하도록 했다.
    /// 앱에서 인터넷(http)과 연결된 지점을 1개로 만든 것이고,
    /// 동시 작업에 대한 처리는 구동 드라이브인 클라이언트 객체에서 담당한다.
    lazy var networkDataService: NetworkDataService = {
       DefaultNetworkDataService(client: AlamofireNetworkClient(),
                                 decoder: JSONResponseDecoder())
    }()
    
    /// 캐릭터 관련 화면들을 제공
    func makeCharactersSceneProvider() -> CharactersSceneProvider {
        CharactersSceneProvider(networkDataService: networkDataService)
    }
}
