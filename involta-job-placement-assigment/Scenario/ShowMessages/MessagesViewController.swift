//
//  ViewController.swift
//  involta-job-placement-assigment
//
//  Created by Maxim Tsyganov on 07.05.2022.
//

import UIKit

class MessagesViewController: UIViewController {

    private var items = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10,]
    private var fetchingMore = false
    private var networkService: NetworkService = {
        let networkService = NetworkService()
        return networkService
    }()

    lazy var messagesTableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.sectionHeaderTopPadding = 0

        tableView.dataSource = self
        tableView.delegate = self

        tableView.register(UITableViewCell.self, forCellReuseIdentifier: UITableViewCell.identifier)
        tableView.register(LoadingCell.self, forCellReuseIdentifier: LoadingCell.identifier)
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGray2

        setupLayout()

    }

    private func setupLayout() {
        view.addSubview(messagesTableView)

        NSLayoutConstraint.activate([
            messagesTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            messagesTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            messagesTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            messagesTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }

}

extension MessagesViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y

        print("offsetY: \(offsetY), \(scrollView.bounds.size.height / 10)")
        if offsetY < -scrollView.bounds.size.height / 10 {
            if !fetchingMore {
                beginBatchFetch(completion: {
                    (scrollView as? UITableView)?.insertItemsAtTopWithFixedPosition(12, inSection: 1)
                })
            }
        }
    }

    func beginBatchFetch(completion: @escaping () -> Void) {
        fetchingMore = true
        print("beginBatchFetch!")
        messagesTableView.reloadSections(IndexSet(integer: 0), with: .none)

        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            let newItems = (self.items.count...self.items.count + 12).map { index in index }
            self.items.insert(contentsOf: newItems.reversed(), at: 0)
            self.fetchingMore = false
            self.messagesTableView.reloadData()
            completion()
        }
    }

}

extension MessagesViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 && fetchingMore {
            return 1
        } else if section == 1 {
            return items.count
        }
        return 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: LoadingCell.identifier, for: indexPath) as! LoadingCell
            cell.startSpinnerAnimation()
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: UITableViewCell.identifier, for: indexPath)
            cell.textLabel?.text = "Item \(items[indexPath.row])"
            return cell
        }
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        2
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        .leastNormalMagnitude
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        .leastNormalMagnitude
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        nil
    }

    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        nil
    }

}
