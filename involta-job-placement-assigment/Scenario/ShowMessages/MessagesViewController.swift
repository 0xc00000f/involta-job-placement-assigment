//
//  ViewController.swift
//  involta-job-placement-assigment
//
//  Created by Maxim Tsyganov on 07.05.2022.
//

import UIKit

class MessagesViewController: UIViewController {

    private var items: [String] = []
    private var isFetching = false
    private var canFetchMore = true
    private let networkService = NetworkService()
    private let pageSize = 20

    lazy var messagesTableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.sectionHeaderTopPadding = 0

        tableView.dataSource = self
        tableView.delegate = self

        tableView.register(MessageCell.self, forCellReuseIdentifier: MessageCell.identifier)
        tableView.register(LoadingCell.self, forCellReuseIdentifier: LoadingCell.identifier)
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        uploadData(to: self.messagesTableView)
    }

    private func setupLayout() {
        view.addSubview(messagesTableView)
        view.backgroundColor = .clear
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
        print("offsetY: \(offsetY), -scrollView.bounds.size.height / 6: \(-scrollView.bounds.size.height / 6)")

        if offsetY < -scrollView.bounds.size.height / 6 {
            cancelCurrentSwipe(of: scrollView)
            uploadData(to: scrollView)
        }
    }

    func uploadData(to scrollView: UIScrollView) {
        if !isFetching {
            beginBatchFetch {[weak self] isFirstBatch, isCancelledCauseError in
                guard let self = self else { return }

                DispatchQueue.main.async {
                    scrollView.setContentOffset(scrollView.contentOffset, animated:false)
                    switch isCancelledCauseError {
                    case false:
                        (scrollView as? UITableView)?.insertItemsAtTopWithFixedPosition(
                            isFirstBatch ? self.pageSize - 1 : self.canFetchMore ? self.pageSize - 2 : self.items.count % self.pageSize,
                            inSection: Section.messages.rawValue
                        )
                    case true:
                        self.showErrorAlertController()
                    }
                    self.isFetching = false
                    self.messagesTableView.reloadData()
                }
            }
        }
    }

    func cancelCurrentSwipe(of scrollView: UIScrollView) {
        scrollView.panGestureRecognizer.isEnabled = false
        scrollView.panGestureRecognizer.isEnabled = true

        scrollView.isUserInteractionEnabled = false
        scrollView.isUserInteractionEnabled = true
    }

    func beginBatchFetch(completion: @escaping (_ isFirstBatch: Bool, _ isCancelledCauseError: Bool) -> Void) {
        let isFirstBatch = self.items.count == 0 ? true : false
        isFetching = true

        if canFetchMore {
            DispatchQueue.main.async {
                self.messagesTableView.reloadSections(IndexSet(integer: Section.loading.rawValue), with: .none)
            }
            networkService.getMessages(offset: items.count) { [weak self] messages, error in
                guard let self = self else {
                    completion(isFirstBatch, true)
                    return
                }
                if error != nil {
                    completion(isFirstBatch, true)
                    return
                }
                DispatchQueue.main.async{
                    self.items.insert(contentsOf: messages.reversed(), at: 0)
                    if messages.count < self.pageSize {
                        self.canFetchMore = false
                    }
                    completion(isFirstBatch, false)
                }
            }}
    }

    func showErrorAlertController() {
        let errorAlertController: UIAlertController = UIAlertController(title: "Error", message: "An error occurred while loading data", preferredStyle: .alert)
        let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        errorAlertController.addAction(cancelAction)
        let retryAction: UIAlertAction = UIAlertAction(title: "Retry", style: .default) { [weak self] _ in
            guard let self = self else { return }
            self.uploadData(to: self.messagesTableView)
        }
        errorAlertController.addAction(retryAction)
        DispatchQueue.main.async {
            self.present(errorAlertController, animated: true, completion: nil)
        }
    }
}

extension MessagesViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == Section.loading.rawValue && isFetching {
            return 1
        } else if section == Section.messages.rawValue {
            return items.count
        }
        return 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case Section.loading.rawValue:
            let cell = tableView.dequeueReusableCell(withIdentifier: LoadingCell.identifier, for: indexPath) as! LoadingCell
            cell.startSpinnerAnimation()
            return cell
        case Section.messages.rawValue:
            let cell = tableView.dequeueReusableCell(withIdentifier: MessageCell.identifier, for: indexPath) as! MessageCell
            cell.messageLabel.preferredMaxLayoutWidth = tableView.bounds.width
            cell.messageLabel.text = "\(items[indexPath.row])"
            return cell
        default:
            return UITableViewCell()
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

fileprivate enum Section: Int {
    case loading = 0
    case messages
}
