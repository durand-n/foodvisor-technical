//
//  FoodlistController.swift
//  Foodvisor-technical
//
//  Created by Benoît Durand on 24/11/2020.
//

import UIKit

protocol FoodlistView: BaseView {
    var onEdit: ((_ food: Food, _ at: Int) -> Void)? { get set }
    
    func didEdit(row: Int)
}

class FoodlistController: UIViewController, FoodlistView {
    var onEdit: ((Food, Int) -> Void)?
    
    private var viewModel: FoodlistViewModelType
    private var tableView = UITableView()
    
    init(viewModel: FoodlistViewModelType) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        tableView.backgroundColor = .white
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
        return cell
    }
    
    func didEdit(row: Int) {
        tableView.reloadRows(at: [IndexPath(row: row, section: 0)], with: .automatic)
        viewModel.saveEdit()
    }
    
    func tableView(_ tableView: UITableView,
      contextMenuConfigurationForRowAt indexPath: IndexPath,
      point: CGPoint) -> UIContextMenuConfiguration? {

        let edit = UIAction(title: "Modifier",
          image: UIImage(systemName: "pencil")) { action in
            if let food = self.viewModel.getFood(row: indexPath.row) {
                self.onEdit?(food, indexPath.row)
            }
        }

        let delete = UIAction(title: "Supprimer",
          image: UIImage(systemName: "trash.fill"),
          attributes: [.destructive]) { action in
            self.viewModel.removeAt(row: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
         }

      return UIContextMenuConfiguration(identifier: nil,
        previewProvider: nil) { _ in
        UIMenu(title: "Actions", children: [edit, delete])
      }
    }
}
