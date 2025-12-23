//
//  IDScanDocumentTypeVC.swift
//  BinbagVerify
//
//  Created by Assistant on 12/11/2025.
//

import UIKit

public final class IDScanDocumentTypeVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    private let tableView = UITableView(frame: .zero, style: .insetGrouped)
    private let types: [IDDocumentType] = IDDocumentType.allCases
    private let headerTitleLabel = UILabel()
    private let backButton = UIButton(type: .system)
    private let cancelButton = UIButton(type: .system)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupHeader()
        setupTable()
    }
    
    private func setupNavigation() {
       // navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(onBack))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(onCancel))
    }
    
    private func setupHeader() {
        // Buttons row
//        backButton.setTitle("Back", for: .normal)
//        backButton.addTarget(self, action: #selector(onBack), for: .touchUpInside)
//        
        cancelButton.setTitle("Cancel", for: .normal)
        cancelButton.addTarget(self, action: #selector(onCancel), for: .touchUpInside)
        
        let spacer = UIView()
        let buttonsRow = UIStackView(arrangedSubviews: [backButton, spacer, cancelButton])
        buttonsRow.axis = .horizontal
        buttonsRow.spacing = 8
        
        // Title
        headerTitleLabel.text = "Select document type"
       // headerTitleLabel.font = UIFont.preferredFont(forTextStyle: .title2).withTraits(.traitBold)
        headerTitleLabel.textColor = .label
        headerTitleLabel.numberOfLines = 1
        
        let stack = UIStackView(arrangedSubviews: [buttonsRow, headerTitleLabel])
        stack.axis = .vertical
        stack.spacing = 12
        stack.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stack)
        
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            stack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            stack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
        ])
    }
    
    private func setupTable() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 96),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    // MARK: - Actions
    @objc private func onBack() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func onCancel() {
        navigationController?.popViewController(animated: true)
    }
    
    // MARK: - UITableViewDataSource
    func numberOfSections(in tableView: UITableView) -> Int { 1 }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { types.count }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let type = types[indexPath.row]
        var content = cell.defaultContentConfiguration()
        content.text = type.title
        cell.contentConfiguration = content
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    // MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let selected = types[indexPath.row]
        let stepsVC = IDScanStepsVC(documentType: selected)
        navigationController?.pushViewController(stepsVC, animated: true)
    }
}


