//
//  SelectRegionViewModel.swift
//  FindCoronaCenter
//
//  Created by mijisuh on 2024/03/12.
//

import Foundation
import Combine

class SelectRegionViewModel: ObservableObject {
    
    @Published var centers = [Center.Sido: [Center]]()
    
    private var cancellables = Set<AnyCancellable>() // disposeBag
    
    init(centerNetwork: CenterNetwork = CenterNetwork()) {
        centerNetwork.getCenterList()
            .receive(on: DispatchQueue.main) // View에 뿌려져야 하므로
            .sink { [weak self] in
                guard case .failure(let error) = $0 else { return }
                print(error.localizedDescription)
                self?.centers = [Center.Sido: [Center]]()
            } receiveValue: { [weak self] centers in
                self?.centers = Dictionary(grouping: centers, by: { $0.sido }) // sido를 key로 하는 딕셔너리 생성
            }
            .store(in: &cancellables) // disposed(by: disposeBag)
    }
    
}
