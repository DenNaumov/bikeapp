//
//  InputField.swift
//  Bike App
//
//  Created by Денис Наумов on 31.08.2020.
//  Copyright © 2020 Денис Наумов. All rights reserved.
//

import UIKit

protocol InputFieldDelegate {
    func textFieldReturn(_ input: InputFieldView) -> Void
    func onTextChange(newValue: String)
}

class InputFieldView: UIView {

    @IBOutlet private weak var label: UILabel!
    @IBOutlet private weak var textField: UITextField!
    @IBOutlet private weak var errorText: UILabel!
    let nibName = "InputField"
    var returnDelegate: InputFieldDelegate? = nil

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initTextField()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        initTextField()
    }

    private func initTextField() {
        guard let view = loadViewFromNib() else { return }
        view.frame = bounds
        addSubview(view)
        textField.delegate = self
    }

    private func loadViewFromNib() -> UIView? {
        let nib = UINib(nibName: nibName, bundle: nil)
        return nib.instantiate(withOwner: self, options: nil).first as? UIView
    }
}

extension InputFieldView: UITextFieldDelegate {

    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.setState(.active)
        removeError()
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        textField.setState(.active)
        returnDelegate?.onTextChange(newValue: string)
        removeError()
        return true
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.setState(.regular)
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        returnDelegate?.textFieldReturn(self)
        return true
    }
}

extension InputFieldView {
    
    func setLabel(text: String) {
        label.text = text
    }
    
    func setKeyboardType(_ type: UIKeyboardType) {
        textField.keyboardType = type
    }
    
    func hideTextEntry() {
        textField.isSecureTextEntry = true
    }
    
    func getText() -> String {
        guard let text = textField.text else { fatalError() }
        return text
    }
    
    func setError(text: String?) {
        textField.setState(.error)
        if let text = text {
            errorText.text = text
        }
    }
    
    func removeError() {
        errorText.text = ""
    }
    
    func isInputText() -> Bool {
        guard let text = textField.text else { return false }
        return !text.isEmpty
    }
    
    @discardableResult override func becomeFirstResponder() -> Bool {
        super.becomeFirstResponder()
        return textField.becomeFirstResponder()
    }
}

private extension UITextField {

    enum State {
        case regular
        case active
        case error
    }

    func setState(_ state: State) {
        switch state {
        case .regular:
            setRegular()
        case .active:
            setActive()
        case .error:
            setError()
        }
    }

    private func setError() {
        layer.borderColor = UIColor.red.cgColor
        layer.borderWidth = 1
    }

    private func setRegular() {
        layer.borderColor = UIColor.green.cgColor
        layer.borderWidth = 0
    }

    private func setActive() {
        layer.borderColor = UIColor.green.cgColor
        layer.borderWidth = 1
    }
}
