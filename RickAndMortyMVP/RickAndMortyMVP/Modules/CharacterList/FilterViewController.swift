//
//  FilterViewController.swift
//  RickAndMortyMVP
//
//  Created by Данила Шабанов on 22.06.2025.
//
import UIKit

protocol FilterDelegate: AnyObject {
    func didApplyFilters(_ filters: CharacterFilter)
    func didResetFilters()
}

final class FilterViewController: UIViewController {
    
    // MARK: - Properties
    weak var delegate: FilterDelegate?
    private var currentFilters = CharacterFilter()
    
    // MARK: - UI Elements
    private lazy var nameTextField: UITextField = {
        let field = UITextField()
        field.placeholder = "Name"
        field.borderStyle = .roundedRect
        field.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        return field
    }()
    
    private lazy var statusSegmentedControl: UISegmentedControl = {
        let control = UISegmentedControl(items: ["Any", "Alive", "Dead", "Unknown"])
        control.selectedSegmentIndex = 0
        control.addTarget(self, action: #selector(statusChanged), for: .valueChanged)
        return control
    }()
    
    private lazy var speciesTextField: UITextField = {
        let field = UITextField()
        field.placeholder = "Species"
        field.borderStyle = .roundedRect
        field.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        return field
    }()
    
    private lazy var genderSegmentedControl: UISegmentedControl = {
        let control = UISegmentedControl(items: ["Any", "Male", "Female", "Genderless", "Unknown"])
        control.selectedSegmentIndex = 0
        control.addTarget(self, action: #selector(genderChanged), for: .valueChanged)
        return control
    }()
    
    private lazy var applyButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Apply Filters", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        button.backgroundColor = .systemBlue
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 8
        button.addTarget(self, action: #selector(applyFilters), for: .touchUpInside)
        return button
    }()
    
    private lazy var resetButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Reset Filters", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        button.setTitleColor(.systemRed, for: .normal)
        button.addTarget(self, action: #selector(resetFilters), for: .touchUpInside)
        return button
    }()
    
    private lazy var stackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [
            createLabel("Name"),
            nameTextField,
            createLabel("Status"),
            statusSegmentedControl,
            createLabel("Species"),
            speciesTextField,
            createLabel("Gender"),
            genderSegmentedControl,
            applyButton,
            resetButton
        ])
        stack.axis = .vertical
        stack.spacing = 16
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    // MARK: - Setup
    private func setupUI() {
        title = "Filters"
        view.backgroundColor = .systemBackground
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .close,
            target: self,
            action: #selector(close)
        )
        
        view.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
    }
    
    private func createLabel(_ text: String) -> UILabel {
        let label = UILabel()
        label.text = text
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        return label
    }
    
    // MARK: - Actions
    @objc private func close() {
        dismiss(animated: true)
    }
    
    @objc private func applyFilters() {
        delegate?.didApplyFilters(currentFilters)
        dismiss(animated: true)
    }
    
    @objc private func resetFilters() {
        nameTextField.text = nil
        speciesTextField.text = nil
        statusSegmentedControl.selectedSegmentIndex = 0
        genderSegmentedControl.selectedSegmentIndex = 0
        currentFilters = CharacterFilter()
        delegate?.didResetFilters()
        dismiss(animated: true)
    }
    
    @objc private func textFieldDidChange(_ textField: UITextField) {
        if textField == nameTextField {
            currentFilters.name = textField.text?.isEmpty == true ? nil : textField.text
        } else if textField == speciesTextField {
            currentFilters.species = textField.text?.isEmpty == true ? nil : textField.text
        }
    }
    
    @objc private func statusChanged(_ sender: UISegmentedControl) {
        currentFilters.status = sender.selectedSegmentIndex == 0 ? nil : {
            switch sender.selectedSegmentIndex {
            case 1: return "alive"
            case 2: return "dead"
            case 3: return "unknown"
            default: return nil
            }
        }()
    }
    
    @objc private func genderChanged(_ sender: UISegmentedControl) {
        currentFilters.gender = sender.selectedSegmentIndex == 0 ? nil : {
            switch sender.selectedSegmentIndex {
            case 1: return "male"
            case 2: return "female"
            case 3: return "genderless"
            case 4: return "unknown"
            default: return nil
            }
        }()
    }
}
