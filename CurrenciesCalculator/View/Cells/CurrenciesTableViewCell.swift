//
//  CurrenciesTableViewCell.swift
//  CurrenciesCalculator
//
//  Created by i.zarubin on 05/10/2018.
//  Copyright © 2018 i.zarubin. All rights reserved.
//

import UIKit

final class CurrenciesTableViewCell: UITableViewCell {
    private var didSetupConstraints = false
    private var model: CurrenciesCellViewModel?

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = UIFont.preferredFont(forTextStyle: .title1)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var textField: UITextField = {
        let textField = UITextField()
        textField.keyboardType = .numberPad
        textField.textAlignment = .right
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        return textField
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initialSetup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialSetup()
    }

    func configure(with model: CurrenciesCellViewModel) {
        titleLabel.text = model.title
        textField.text = model.value
        if model.editing {
            textField.isUserInteractionEnabled = true
            textField.becomeFirstResponder()
        } else {
            textField.isUserInteractionEnabled = false
        }
        self.model = model
    }

    override func updateConstraints() {
        if !didSetupConstraints {
            setupTitleLabelConstraints()
            setupTextFieldConstraints()
            didSetupConstraints = true
        }
        super.updateConstraints()
    }
}

private extension CurrenciesTableViewCell {
    func initialSetup() {
        contentView.addSubview(titleLabel)
        contentView.addSubview(textField)
        setNeedsUpdateConstraints()
    }

    func setupTitleLabelConstraints() {
        titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: ViewSize.sideOffset).isActive = true
        titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        titleLabel.trailingAnchor.constraint(lessThanOrEqualTo: textField.leadingAnchor, constant: ViewSize.interItemOffset).isActive = true
    }

    func setupTextFieldConstraints() {
        textField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -ViewSize.sideOffset).isActive = true
        textField.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        textField.widthAnchor.constraint(lessThanOrEqualToConstant: 200).isActive = true
    }

    @objc
    func textFieldDidChange(_ sender: UITextField) {
        guard let model = self.model else {
            return
        }
        model.onChangeText?(model, sender.text ?? "")
    }
}
