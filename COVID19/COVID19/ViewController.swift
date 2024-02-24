//
//  ViewController.swift
//  COVID19
//
//  Created by mijisuh on 2024/02/24.
//

import UIKit
import Charts
import Alamofire

class ViewController: UIViewController {

    @IBOutlet weak var totalCaseLabel: UILabel!
    @IBOutlet weak var newCaseLable: UILabel!
    @IBOutlet weak var pieChartView: PieChartView!
    @IBOutlet weak var labelStackView: UIStackView!
    @IBOutlet weak var indicatorView: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.indicatorView.startAnimating() // 인디케이터 애니메이션 시작
        self.fetchCovidOverview { [weak self] result in
            guard let self = self else { return }
            self.indicatorView.stopAnimating() // 인디케이터 애니메이션 종료
            self.indicatorView.isHidden = true
            self.labelStackView.isHidden = false
            self.pieChartView.isHidden = false
            switch result {
            case let .success(result):
                self.configureStackView(koreaCovidOverview: result.korea)
                let covieOverviewList = self.makeCovidOverviewList(cityCovidOverview: result)
                self.configureChartView(covidOverviewList: covieOverviewList)
            case let .failure(error):
                debugPrint("error \(error)")
            }
        }
    }
    
    func makeCovidOverviewList(cityCovidOverview: CityCovidOverview) -> [CovidOverview] {
        // JSON 객체 -> 배열
        return [
            cityCovidOverview.seoul,
            cityCovidOverview.busan,
            cityCovidOverview.daegu,
            cityCovidOverview.incheon,
            cityCovidOverview.gwangju,
            cityCovidOverview.daejeon,
            cityCovidOverview.ulsan,
            cityCovidOverview.sejong,
            cityCovidOverview.gyeonggi,
            cityCovidOverview.chungbuk,
            cityCovidOverview.chungnam,
            cityCovidOverview.gyeongbuk,
            cityCovidOverview.gyeongnam,
            cityCovidOverview.jeju,
        ]
    }
    
    func configureChartView(covidOverviewList: [CovidOverview]) {
        self.pieChartView.delegate = self
        
        // CovidOverview 객체를 PieChartDataEntry 객체로 맵핑
        let entries = covidOverviewList.compactMap { [weak self] overview -> PieChartDataEntry? in
            guard let self = self else { return nil }
            return PieChartDataEntry(
                value: self.removeFormatString(overview.newCase),
                label: overview.countryName,
                data: overview
            )
        }
        
        let dataSet = PieChartDataSet(entries: entries, label: "코로나 발생 현황")
        dataSet.sliceSpace = 1 // 항목 간 간격 1pt 떨어지도록 설정
        dataSet.entryLabelColor = .black // 항목 이름 색상 설정
        dataSet.valueTextColor = .black // 항목 값 색상 설정
        dataSet.xValuePosition = .outsideSlice // 항목 이름이 파이 차트 바깥에서 보이도록 설정
        
        // 항목의 이름을 가독성 좋게 표시
        dataSet.valueLinePart1OffsetPercentage = 0.8
        dataSet.valueLinePart1Length = 0.2
        dataSet.valueLinePart2Length = 0.3
        
        // 차트 컬러가 다양해지도록 설정
        dataSet.colors = ChartColorTemplates.vordiplom() +
            ChartColorTemplates.joyful() +
            ChartColorTemplates.liberty() +
            ChartColorTemplates.pastel() +
            ChartColorTemplates.material()
        
        self.pieChartView.data = PieChartData(dataSet: dataSet)
        
        // 현재 상태보다 80도 회전된 상태로 보여줌
        self.pieChartView.spin(duration: 0.3, fromAngle: self.pieChartView.rotationAngle, toAngle: self.pieChartView.rotationAngle + 80)
    }
    
    func removeFormatString(_ string: String) -> Double {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter.number(from: string)?.doubleValue ?? 0
    }
    
    func configureStackView(koreaCovidOverview: CovidOverview) {
        // Alamofire에서는 response() 메서드의 completionHandler는 메인 스레드에서 동작하기 때문에 따로 메인 스레드에서 작업하지 않아도 됨
        self.totalCaseLabel.text = "\(koreaCovidOverview.totalCase)명"
        self.newCaseLable.text = "\(koreaCovidOverview.newCase)명"
    }
    
    func fetchCovidOverview(completionHandler: @escaping (Result<CityCovidOverview, Error>) -> Void) {
        // completionHander를 전달 받아 API 요청을 응답 받거나 요청이 실패했을 때 completionHander를 호출하여 해당 클로저를 정의한 곳에 응답 데이터 전송
        // 요청이 성공하면 CovidOverview 형 데이터를, 실패하면 Error 형 데이터를 열거형(Result) 연관값으로 전달
        guard let apiKey = Bundle.main.object(forInfoDictionaryKey: "API_KEY") as? String else { return }
        let url = "https://api.corona-19.kr/korea/country/new/"
        let param = [ // 쿼리 파라미터를 딕셔너리 형태로 생성
            "serviceKey": apiKey
        ]
        
        AF.request(url, method: .get, parameters: param)
            .response(completionHandler: { response in // 응답 데이터가 클로저 파라미터로 전달됨
                switch response.result { // 열거형 타입
                // 요청 성공
                case let .success(data): // 연관값으로 응답 데이터가 들어있음
                    do {
                        let decoder = JSONDecoder()
                        let result = try decoder.decode(CityCovidOverview.self, from: data!) // CityCovidOverview 객체로 맵핑
                        completionHandler(.success(result))
                    } catch { // CityCovidOverview 객체로 맵핑 실패 시
                        completionHandler(.failure(error))
                    }
                // 요청 실패
                case let .failure(error): // 연관값으로 에러 데이터가 들어있음
                    completionHandler(.failure(error))
                }
            })
    }

}

extension ViewController: ChartViewDelegate {
    
    // 차트에서 항목  클릭 시 호출되는 메서드
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        // entry 파라미터를 통해 선택한 항목에 저장된 데이터를 가져올 수 있음
        guard let covidDetailViewController = self.storyboard?.instantiateViewController(withIdentifier: "CovidDetailTableViewController") as? CovidDetailTableViewController else { return }
        
        guard let covidOverview = entry.data as? CovidOverview else { return }
        covidDetailViewController.covidOverview = covidOverview
        self.navigationController?.pushViewController(covidDetailViewController, animated: true)
    }
    
}
