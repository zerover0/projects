### 2016-05-04 report

* OpenTSDB 데이터 구조 수정
  - EE 데이터를 위한 새로운 metric 정의
    - ee.meter.power.lp.active - 유효전력량
    - ee.meter.power.lp.aph - 누적 유효전력량
    - ee.meter.power.lp.error1 - 데이터 오류유형1, 통신장애
    - ee.meter.power.lp.error2 - 데이터 오류유형2, 날짜오류
    - ee.meter.power.lp.error3 - 데이터 오류유형3, 부하이력에서 데이터 누락
  - EE 데이터를 위한 tag 정의
    - mdsid : 미터기 MDS_ID
    - wday : 요일
    - SIC, location 등의 데이터를 tag로 추가했을 때 한글 입력은 되지만 다양한 데이터오류가 발생해서 최종적으로 삭제함
  - 새 데이터 구조에 맞추어 오라클 데이터를 OpenTSDB로 복사 수행
    - 오라클 데이터를 로그 파일로 저장
      - 저장위치: /home/tinyos16/KETI/EE/data
    - 로그 파일을 읽어서 OpenTSDB에 저장
      - 데이터 저장 프로그램: tsdb_lp_put_test.py, tsdb_lp_month_put_test.py
      - GitHub: https://github.com/jeonghoonkang/keti/tree/master/EE/aimir/python
* Grafana dashboard 추가
  - 검침실패 실시간 모니터링 dashboard 추가
    - Dashboard URL: http://ee:3000/dashboard/db/geomcimsilpae-silsigan-bunseog
  - Dashboard script 추가
    - MDS_ID를 인자로 받아서 해당 미터기의 유효전력량 그래프와 테이블, 데이터 오류 이력 테이블 출력
    - 스크립트 파일위치: /usr/share/grafana/public/dashboards/ee.js
    - 스크립트 URL: http://49.254.13.34:3000/dashboard/script/ee.js?mdsid=01221401193-0001%7C01221281194-0001%7C01221281194-0002
      - 쿼리문자열에서 'mdsid=' 뒤에 '|' 기호를 써서 보고싶은 MDS_ID들을 연결해서 나열하면 함께 보여진다.
  - GitHub: https://github.com/jeonghoonkang/keti/tree/master/EE/aimir/grafana/script/
* Django에 SVC 앱 추가
  - 임박사님이 만드신 Scikit-learn SVC 알고리즘을 사용한 유형판별 코드를 Django 앱으로 연결시켜 시험함
  - SVC앱 URL: http://49.254.13.34:8000/predict/
  - SVC앱 파일위치: /home/tinyos16/KETI/EE/source/ee/
  
