//
//  EditorViewController.swift
//  TintThat
//
//  Created by Sebastian Cruz on 08/06/21.
//

import UIKit

final class EditorViewController: UIViewController {

    // MARK: - Properties
    private var collection = Collection(title: "", palettes: []) {
        didSet {
            titleLabel.text = collection.title
        }
    }
    
    private let colorCellID = "ColorCell"
    private let emptyCellID = "EmptyCell"
    private let headerCellID = "HeaderCell"
    private let footerCellID = "FooterCell"
    private let colorCellHeight: CGFloat = 44.0
    private let headerCellHeight: CGFloat = 52.0
    private let footerViewHeight: CGFloat = 52.0
    private let sectionMarginHeight: CGFloat = 16.0
    
    // MARK: - Outlets
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var collectionTB: UITableView!
    
    // MARK: - UIViewController
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initialSetup()
    }

}

// MARK: - Private
private extension EditorViewController {
    
    func initialSetup() {
        view.backgroundColor = .primaryLight
        
        // Test (remove this)
        collection = Collection(title: "Collection", palettes: [Palette(colors: [.init(color: .secondaryAltDark), .init(color: .secondaryAltLight), .init(color: .primaryAltDark)]), Palette(colors: [.init(color: .secondaryAltDark), .init(color: .secondaryAltLight), .init(color: .primaryAltDark)]), Palette(colors: [.init(color: .secondaryAltDark), .init(color: .secondaryAltLight), .init(color: .primaryAltDark)])])
        
        // Setup main tab bar
        if let items = tabBarController?.tabBar.items {
            items[0].image = .editorIcon
            items[0].title = .editor
            items[1].title = .myPalettes
            items[1].image = .myPalettesIcon
            items[2].title = .settings
            items[2].image = .settingsIcon
        }
        
        // Setup titleLabel
        titleLabel.textColor = .primaryDark
        titleLabel.font = .customTitle
        titleLabel.backgroundColor = .secondaryLight
        
        // Setup optionsBtn
        //let optionsBtn = navigationItem.rightBarButtonItem?.customView?.subviews[0] as! UIButton
        //optionsBtn.setImage(optionsBtn.image(for: .normal)?.alpha(0.5), for: .highlighted)
        //optionsBtn.tintColor = .primaryAltDark
        //optionsBtn.setImage(.optionsIcon.alpha(0.5), for: .highlighted)
        setupOptionsBtn()
        
        // Setup collection table view
        collectionTB.contentInset = UIEdgeInsets(top: 16,left: 0,bottom: 0,right: 0)
        collectionTB.backgroundColor = .primaryLight
        collectionTB.register(EditorHeaderView.self, forHeaderFooterViewReuseIdentifier: headerCellID)
        collectionTB.register(EditorFooterView.self, forHeaderFooterViewReuseIdentifier: footerCellID)
    }
    
    func setupOptionsBtn() {
        let optionsBtn = UIButton(type: .custom)
        optionsBtn.frame = CGRect(x: 0.0, y: 0.0, width: 28, height: 28)
        optionsBtn.setImage(.optionsIcon, for: .normal)
        optionsBtn.setImage(.optionsIcon.alpha(0.5), for: .highlighted)
        
        let rightBarItem = UIBarButtonItem(customView: optionsBtn)
        rightBarItem.customView?.widthAnchor.constraint(equalToConstant: 28).isActive = true
        rightBarItem.customView?.heightAnchor.constraint(equalToConstant: 28).isActive = true
        
        navigationItem.rightBarButtonItem = rightBarItem
    }
    
}

// MARK: - UITableViewDelegate
extension EditorViewController: UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if collection.isEmpty {
            return 1
        }
        
        return collection.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if collection.isEmpty {
            return 0
        }
        
        return footerViewHeight + sectionMarginHeight
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if collection.isEmpty {
            return UITableView.automaticDimension
        }
        
        return colorCellHeight
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if collection.isEmpty {
            return nil
        }
        
        let footer = tableView.dequeueReusableHeaderFooterView(withIdentifier: footerCellID)
        
        return footer
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if collection.isEmpty {
            return 0
        }
        
        return headerCellHeight
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if collection.isEmpty {
            return nil
        }
        
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: headerCellID) as? EditorHeaderView
        
        header?.titleLabel.text = collection.titleOfPalette(in: section)
        
        return header
    }
    
}

// MARK: - UITableViewDataSource
extension EditorViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if collection.isEmpty {
            return 1
        }
        
        return collection.numberOfColors(in: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if collection.isEmpty {
            let cell = tableView.dequeueReusableCell(withIdentifier: emptyCellID, for: indexPath)
            cell.backgroundColor = .primaryLight
            let label = cell.contentView.subviews[0] as! UILabel
            label.text = .empty
            label.textColor = .primaryDark
            label.font = .customHeadline
            return cell
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: colorCellID, for: indexPath)
        cell.contentView.backgroundColor = .primaryAltLight
        cell.contentView.subviews[0].backgroundColor = collection.colorOfPalette(in: indexPath.section, forRow: indexPath.row).color
        let colorBtn = cell.contentView.subviews[1] as! UIButton
        colorBtn.tintColor = .primaryAltDark
        colorBtn.setImage(.optionsIcon.alpha(0.5), for: .highlighted)
        
        return cell
    }
      
}
