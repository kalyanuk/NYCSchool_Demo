//
//  ErrorView.swift
//  NYCSchools
//
//  Created by Kalyan Boddapati on 07/08/2021.
//

import UIKit

class ErrorView : UIView
{
    var errorMessage: String {
        get {
            return self.errLabel.text ?? ""
        }
        set {
            self.errLabel.text = newValue
        }
    }
   
    var reloadData: (()->Void)?
    
    private var errLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        return label
    }()
    
    private var reloadBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.setTitle("reload", for: .normal)
        btn.setTitleColor(.systemBlue, for: .normal)
        btn.setImage( UIImage(systemName: "arrow.counterclockwise"), for: .normal)
        return btn
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .gray
        errLabel.frame = CGRect(x: 20, y: frame.size.height/2 - 180, width: frame.size.width - 40, height: 40)
        reloadBtn.frame = CGRect(x: 20, y: frame.size.height/2 - 120, width: frame.size.width - 40, height: 40)
        reloadBtn.addTarget(self, action: #selector(actionReload), for: .touchUpInside)
        self.addSubview(errLabel)
        self.addSubview(reloadBtn)
    }
    
    @objc func actionReload() {
        if let reload = reloadData {
            reload()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


