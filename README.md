# iOS Clean Architecture Workout

## 마블 빌런 조회 구현  

- API : [https://developer.marvel.com](https://developer.marvel.com)
- 페이지 단위 무한 스크롤
- 즐겨찾기 화면 
- etag 처리 
- 간단한 상세 화면

## Architecture

* 클린 아키텍트 이론에 기반해 도메인, 데이터, 프리젠테이션, 인프라로 구분.
* UIKit 기반 뷰 구성, SwiftUI 미리보기 작성
* MVVM 방식 뷰 업데이트 구성 
* minimum target : iOS 15.0

---

TODO: 
- [x] local caching api reseponses 
- [ ] 즐겨찾기 화면에서 수정된 정보 반영하기
- [ ] 리포지토리 조회를 비동기함수로 수정
- [ ] 원격 데이터 먼저 조회하기 (etag 적극활용, 타임아웃 짧게 수정)
- [ ] 원격 데이터와 캐시데이터 구분없이 하나로 변경
- [ ] 네트워크 단절시 상태 표시
- [ ] 상세화면을 단독 프로젝트로 구성 (모듈화 테스트)
