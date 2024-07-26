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
