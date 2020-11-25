//
//  FoodlistController.swift
//  Foodvisor-technical
//
//  Created by Benoît Durand on 24/11/2020.
//

import UIKit

protocol FoodlistView: BaseView {
    
}

class FoodlistController: UIViewController, FoodlistView {
    private var viewModel: FoodlistViewModelType
    private var tableView = UITableView()
    
    init(viewModel: FoodlistViewModelType) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        tableView.registerCellClass(FoodlistCell.self)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorColor = .clear
        tableView.separatorStyle = .none
        tableView.estimatedRowHeight = 232.0
        tableView.rowHeight = UITableView.automaticDimension
        
        title = "Recettes"
        self.viewModel.onShowData = {
            self.tableView.reloadData()
        }
        viewModel.initFoodlist()
        designView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func designView() {
        view.backgroundColor = .background
        view.addSubview(tableView)
        tableView.setConstraintsToSuperview()
        tableView.backgroundColor = .background
    }
}

extension FoodlistController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.foodCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withClass: FoodlistCell.self)
        if let data = viewModel.getDatafor(row: indexPath.row) {
            cell.setContent(data: data)
        }
        
//        cell.layer.insertSublayer(gradient(frame: cell.bounds), at: 0)
        return cell
    }
    
    
}
