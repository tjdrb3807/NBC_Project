//
//  MainViewController.swift
//  NBC_PhoneBook
//
//  Created by 전성규 on 12/9/24.
//

import UIKit
import SnapKit

final class MainViewController: BaseViewController {
    private lazy var phoneBookTableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.register(
            PhoneBookTableViewCell.self,
            forCellReuseIdentifier: PhoneBookTableViewCell.identifier)
        
        tableView.dataSource = self
        tableView.delegate = self
        
        return tableView
    }()
    
    override func configureNavigationBar() {
        super.configureNavigationBar()
        
        navigationItem.title = "친구목록"
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "추가",
            style: .done,
            target: self,
            action: #selector(rightBarButtonDidTap))
    }
    
    override func configureUI() {
        super.configureUI()
        view.addSubview(phoneBookTableView)
    }
    
    override func setupConstraints() {
        phoneBookTableView.snp.makeConstraints {
            $0.top.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(20.0)
            $0.bottom.equalToSuperview()
        }
    }
    
    @objc private func rightBarButtonDidTap() {
        navigationController?.pushViewController(PhoneBookViewController(), animated: true)
    }
}

extension MainViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: PhoneBookTableViewCell.identifier,
            for: indexPath) as? PhoneBookTableViewCell else { return UITableViewCell() }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        80.0
    }
}

#if DEBUG

import SwiftUI

struct MainViewController_Previews: PreviewProvider {
    static var previews: some View {
        MainViewController_Presentable()
    }
    
    struct MainViewController_Presentable: UIViewControllerRepresentable {
        func makeUIViewController(context: Context) -> some UIViewController {
            UINavigationController(rootViewController: MainViewController())
        }
        
        func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) { }
    }
}

#endif
