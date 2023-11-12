//
//  ViewController.swift
//  SparrowCodeTable
//
//  Created by Юрий Степанчук on 12.11.2023.
//

import UIKit

final class ViewController: UIViewController {
    private typealias DataSource = UITableViewDiffableDataSource<Int, Content>
    private var dataSource: DataSource!

    private lazy var data = {
        var data = [Content]()
        for number in 0...30 {
            data.append(Content(title: "\(number)", isChecked: false))
        }
        return data
    }()

    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.register(UITableViewCell.self)
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupDataSource()
        setNavigationBar()
    }

    private func setupDataSource() {
        dataSource = makeDataSource()

        var snapshot = NSDiffableDataSourceSnapshot<Int, Content>()
        snapshot.appendSections([0])
        snapshot.appendItems(data)
        dataSource.apply(snapshot, animatingDifferences: false)
    }

    private func makeDataSource() -> DataSource {
        return DataSource(tableView: tableView) { tableView, indexPath, model in
            let cell = tableView.dequeueReusableCell(withIdentifier: UITableViewCell.reuseIdentifier, for: indexPath)
            var content = cell.defaultContentConfiguration()
            content.text = model.title
            cell.contentConfiguration = content
            cell.accessoryType = model.isChecked ? .checkmark : .none
            return cell
        }
    }

    private func setupView() {
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    private func setNavigationBar() {
        navigationItem.title = "Task 4"
        let shuffleButton = UIBarButtonItem(title: "Shuffle", style: .plain, target: self, action: #selector(shuffleButtonTapped))
        navigationItem.rightBarButtonItem = shuffleButton
    }

    @objc private func shuffleButtonTapped() {
        data.shuffle()
        applySnapshot()
    }

    private func applySnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<Int, Content>()
        snapshot.appendSections([0])
        snapshot.appendItems(data)
        dataSource.apply(snapshot, animatingDifferences: true)
    }
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        guard let item = dataSource.itemIdentifier(for: indexPath) else { return }
        
        var newSnapshot = dataSource.snapshot()
        if !item.isChecked, indexPath != IndexPath(row: 0, section: 0) {
            newSnapshot.moveItem(item, beforeItem: dataSource.itemIdentifier(for: IndexPath(row: 0, section: 0))!)
        }
        item.isChecked.toggle()
        newSnapshot.reloadItems([item])
        dataSource.apply(newSnapshot)
    }
}
