//
//  FoodlistController.swift
//  Foodvisor-technical
//
//  Created by Benoît Durand on 24/11/2020.
//

import UIKit

protocol FoodlistView: BaseView {
    var onEdit: ((_ food: Food, _ at: Int, _ create: Bool) -> Void)? { get set }
    
    func didEdit(row: Int)
    func didCreate(food: Food, at: Int)
}

class FoodlistController: UIViewController, FoodlistView {
    var onEdit: ((_ food: Food, _ at: Int, _ create: Bool) -> Void)?
    
    private var viewModel: FoodlistViewModelType
    private var tableView = UITableView()
    private var emptyLabel = UILabel(title: "Rien à afficher", type: .semiBold, color: .gray, size: 16, lines: 1, alignment: .center)
    
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
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(addTapped))
        title = "Recettes"
        self.viewModel.onShowData = { [weak self] in
            self?.tableView.reloadData()
        }
        
        self.viewModel.onShowError = { [weak self] error in
            self?.showError(message: error)
        }
        viewModel.initFoodlist()
        designView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func designView() {
        view.backgroundColor = .background
        view.addSubviews([tableView, emptyLabel])
        tableView.setConstraintsToSuperview()
        emptyLabel.setConstraintsToSuperview()
        tableView.backgroundColor = .background
    }
    
    @objc func addTapped() {
        if let food = self.viewModel.createFood() {
            self.onEdit?(food, tableView.numberOfRows(inSection: 0), true)
        }
    }
}

extension FoodlistController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let rowCount = viewModel.foodCount
        if rowCount == 0 {
            emptyLabel.fadeIn()
        } else {
            emptyLabel.fadeOut()
        }
        return rowCount
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
    
    func didCreate(food: Food, at: Int) {
        viewModel.insertFood(food: food)
        tableView.insertRows(at: [IndexPath(row: at, section: 0)], with: .automatic)
    }
    
    func tableView(_ tableView: UITableView,
      contextMenuConfigurationForRowAt indexPath: IndexPath,
      point: CGPoint) -> UIContextMenuConfiguration? {

        let edit = UIAction(title: "Modifier",
          image: UIImage(systemName: "pencil")) { action in
            if let food = self.viewModel.getFood(row: indexPath.row) {
                self.onEdit?(food, indexPath.row, false)
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
