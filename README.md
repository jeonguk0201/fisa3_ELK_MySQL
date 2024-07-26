# fisa3_ELK_MySQL

이 문서는 Ubuntu에서 Elasticsearch, Logstash, Kibana, Filebeat를 설치하고 구성하는 방법에 대해 설명합니다.

## 전제 조건

시스템이 최신 상태인지 확인합니다.
```sh
sudo apt update
sudo apt upgrade -y
```
필요한 패키지를 설치합니다.

``` sh
sudo apt install apt-transport-https curl -y
```

물론입니다. 아래는 한글로 된 설명과 함께 마크다운 형식으로 작성된 ELK 스택과 Filebeat 설치 가이드입니다. 이 내용을 GitHub README 파일에 사용할 수 있습니다.

markdown
코드 복사
# ELK 스택 및 Filebeat 설치 가이드

이 문서는 Ubuntu에서 Elasticsearch, Logstash, Kibana, Filebeat를 설치하고 구성하는 방법에 대해 설명합니다.

## 전제 조건

시스템이 최신 상태인지 확인합니다.
```sh
sudo apt update
sudo apt upgrade -y
```
필요한 패키지를 설치합니다.

```sh
sudo apt install apt-transport-https curl -y
```
## Elasticsearch 설치
1. Elasticsearch PGP 키를 가져옵니다.
``` sh
curl -fsSL https://artifacts.elastic.co/GPG-KEY-elasticsearch | sudo gpg --dearmor -o /usr/share/keyrings/elasticsearch-archive-keyring.gpg
```

2. Elasticsearch 저장소를 추가합니다.
``` sh
echo "deb [signed-by=/usr/share/keyrings/elasticsearch-archive-keyring.gpg] https://artifacts.elastic.co/packages/7.x/apt stable main" | sudo tee /etc/apt/sources.list.d/elastic-7.x.list
```
3. Elasticsearch를 설치합니다.
``` sh
sudo apt update
sudo apt install elasticsearch -y
```
4. Elasticsearch 서비스를 활성화하고 시작합니다.
``` sh
sudo systemctl enable elasticsearch
sudo systemctl start elasticsearch
```
## Logstash 설치
1. Logstash를 설치합니다.
``` sh
sudo apt install logstash -y
```
2. Logstash 서비스를 활성화하고 시작합니다.
``` sh
sudo systemctl enable logstash
sudo systemctl start logstash
```
## Kibana 설치
1. Kibana를 설치합니다.
``` sh
sudo apt install kibana -y
```
2. Kibana 서비스를 활성화하고 시작합니다.
``` sh
sudo systemctl enable kibana
sudo systemctl start kibana
```

## Logstash 구성
1. Logstash 구성 파일 생성:
``` sh
sudo vim /etc/logstash/conf.d/titanic.conf
```
2. 다음 구성 추가
``` sh
input {
  jdbc {
    jdbc_driver_library => "/usr/share/logstash/logstash-core/lib/jars/mysql-connector-java-8.0.26.jar"
    jdbc_driver_class => "com.mysql.cj.jdbc.Driver"
    jdbc_connection_string => "jdbc:mysql://localhost:3306/fisa"
    jdbc_user => "root"
    jdbc_password => "root"
    statement => "SELECT passengerid AS id, survived, pclass, name, gender, age, sibsp, parch, ticket, fare, cabin, embarked FROM titanic_raw"
  }
}

output {
  elasticsearch {
    hosts => ["localhost:9200"]
    index => "titanic"
    document_id => "%{id}"
  }
}
```
3. Logstash 구성 테스트:
``` sh
sudo -u logstash /usr/share/logstash/bin/logstash --path.settings /etc/logstash -t
```
4. Logstash 재시작:
``` sh
sudo systemctl restart logstash
```

## Kibana 접근

1. 웹 브라우저를 열고 `http://localhost:5601`로 이동합니다.
2. Kibana 대시보드가 표시됩니다. 여기서 데이터를 탐색하고 시각화할 수 있습니다.


## titanic data table
1. 기존 테이블 데이터 확인
```
Field      |Type        |Null|Key|Default|Extra|
-----------+------------+----+---+-------+-----+
passengerid|int         |NO  |   |       |     |
survived   |int         |YES |   |       |     |
pclass     |int         |YES |   |       |     |
name       |varchar(100)|YES |   |       |     |
gender     |varchar(50) |YES |   |       |     |
age        |double      |YES |   |       |     |
sibsp      |int         |YES |   |       |     |
parch      |int         |YES |   |       |     |
ticket     |varchar(80) |YES |   |       |     |
fare       |double      |YES |   |       |     |
cabin      |varchar(50) |YES |   |       |     |
embarked   |varchar(20) |YES |   |       |     |
```
2. 결측치 제거
``` sql
-- 평균 나이를 계산하여 변수에 저장
SET @avg_age = (SELECT ROUND(AVG(age), 0) FROM titan WHERE age IS NOT NULL);

-- 그 변수를 사용하여 업데이트
UPDATE titan
SET age = @avg_age
WHERE age is null;
```

3. age_group 추가:
   데이터 시각화를 위해 나이를 그룹화 진행
``` sql
ALTER TABLE titan ADD COLUMN age_group VARCHAR(10);

UPDATE titan
SET age_group = CASE
	WHEN age < 0 THEN 'others'
    WHEN age >= 0 AND age < 5 THEN '0-4'
    WHEN age >= 5 AND age < 10 THEN '5-9'
    WHEN age >= 10 AND age < 15 THEN '10-14'
    WHEN age >= 15 AND age < 20 THEN '15-19'
    WHEN age >= 20 AND age < 25 THEN '20-24'
    WHEN age >= 25 AND age < 30 THEN '25-29'
    WHEN age >= 30 AND age < 35 THEN '30-34'
    WHEN age >= 35 AND age < 40 THEN '35-39'
    WHEN age >= 40 AND age < 45 THEN '40-44'
    WHEN age >= 45 AND age < 50 THEN '45-49'
    WHEN age >= 50 AND age < 55 THEN '50-54'
    WHEN age >= 55 AND age < 60 THEN '55-59'
    WHEN age >= 60 AND age < 65 THEN '60-64'
    WHEN age >= 65 AND age < 70 THEN '65-69'
    WHEN age >= 70 AND age < 75 THEN '70-74'
    WHEN age >= 75 AND age < 80 THEN '75-79'
    WHEN age >= 80 AND age < 85 THEN '80-84'
    WHEN age >= 85 AND age < 90 THEN '85-89'
    WHEN age >= 90 AND age < 95 THEN '90-94'
    WHEN age >= 95 AND age < 100 THEN '95-99'
    ELSE NULL
END;
```
   결과
```
Field      |Type        |Null|Key|Default|Extra|
-----------+------------+----+---+-------+-----+
passengerid|int         |NO  |   |       |     |
survived   |int         |YES |   |       |     |
pclass     |int         |YES |   |       |     |
name       |varchar(100)|YES |   |       |     |
gender     |varchar(50) |YES |   |       |     |
age        |double      |YES |   |       |     |
sibsp      |int         |YES |   |       |     |
parch      |int         |YES |   |       |     |
ticket     |varchar(80) |YES |   |       |     |
fare       |double      |YES |   |       |     |
cabin      |varchar(50) |YES |   |       |     |
embarked   |varchar(20) |YES |   |       |     |
age_group  |varchar(10) |YES |   |       |     |
```
