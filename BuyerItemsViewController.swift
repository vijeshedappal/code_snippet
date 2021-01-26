//
//  BuyerItemsViewController.swift
//  CookaniApp
//
//  Created by Vijesh Vijayan on 12/05/20.
//  Copyright © 2020 Ponnooz. All rights reserved.


import UIKit
import ViewAnimator
import Kingfisher


class BuyerItemsViewController: UIViewController {
    
    private var categories: [CategoryModel]?
    private var selectedCategory: String?
    
    private let userCartButton: RoundedButton = {
        let button = RoundedButton(type: .custom)
        button.iconImage = UIImage(named: "add-to-cart")
        button.iconColor = .black
        button.borderColor = AppColor.secondaryColor
        button.badgeColor = AppColor.primaryColor
        button.badgeRadius = 15
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private let userOrdersButton: RoundedButton = {
        let button = RoundedButton(type: .custom)
        button.iconImage = UIImage(named: "order-icon")
        button.iconColor = .black
        button.borderColor = AppColor.secondaryColor
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let userProfileButton: RoundedButton = {
        let button = RoundedButton(type: .custom)
        button.backgroundImage = UIImage(named: "profile-pic")
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let trailingButtonView: UIView = {
        let view = UIView()
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let layerView: HeaderViewDemo = {
        let view = HeaderViewDemo()
        view.backgroundColor = .white
        view.minimumHeight = 100
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    
    private lazy var categoryPickerView: CategoryPickerView = {
        let menubar = CategoryPickerView()
        menubar.semanticContentAttribute = AppManager.isLanguageEnglish ? .forceLeftToRight : .forceRightToLeft
        menubar.delegate = self
        menubar.categories = self.categories
        menubar.translatesAutoresizingMaskIntoConstraints = false
        return menubar
    }()
    
    private lazy var listAttendanceView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 20
        layout.minimumLineSpacing = 10
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = AppColor.whiteColorPrimary
        cv.dataSource = self
        cv.delegate = self
        cv.showsVerticalScrollIndicator = false
        cv.alwaysBounceVertical = true
        cv.translatesAutoresizingMaskIntoConstraints = false
        return cv
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.defaultBold(size: 20)
        label.textColor = UIColor.black
        label.textAlignment = .natural
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let searchField: IconTextField = {
        let textField = IconTextField(frame: .zero)
        textField.leftPadding = 40
        textField.rightPadding = 40
        textField.cornerRadius = 10
        textField.lineInset = 1
        textField.lineType = .none
        textField.lineColor = AppColor.layerColor
        textField.keyboardType = UIKeyboardType.default
        textField.returnKeyType = UIReturnKeyType.search
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    
    private var widthAnchorConstraint: NSLayoutConstraint!
    private var lastOffset: CGFloat = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = AppColor.whiteColorPrimary
        
        view.addSubview(listAttendanceView)
        listAttendanceView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant:0).isActive = true
        listAttendanceView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0).isActive = true
        listAttendanceView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        listAttendanceView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        listAttendanceView.register(ProductCell.self)
        listAttendanceView.register(ErrorDataCell.self)
        listAttendanceView.register(BaseReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader)
        listAttendanceView.register(BaseReusableFooterView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter)
        listAttendanceView.contentInset = UIEdgeInsets(top: 215, left: 0, bottom: self.menuBarBottomInsets + 40, right: 0)
        
        view.addSubview(layerView)
        layerView.scrollView = listAttendanceView
        layerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0).isActive = true
        layerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0).isActive = true
        layerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0).isActive = true
        
        layerView.addSubview(categoryPickerView)
        categoryPickerView.bottomAnchor.constraint(equalTo: layerView.bottomAnchor, constant: 0).isActive = true
        categoryPickerView.leadingAnchor.constraint(equalTo: layerView.leadingAnchor).isActive = true
        categoryPickerView.trailingAnchor.constraint(equalTo: layerView.trailingAnchor).isActive = true
        
        layerView.addSubview(titleLabel)
        titleLabel.text = AppStrings.Titles.categories
        titleLabel.bottomAnchor.constraint(equalTo: categoryPickerView.topAnchor, constant: -10).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: layerView.leadingAnchor, constant: 15).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: layerView.trailingAnchor, constant: -15).isActive = true
        titleLabel.setContentHuggingPriority(.defaultHigh, for: .vertical)
        
        
        
        layerView.addSubview(trailingButtonView)
        trailingButtonView.bottomAnchor.constraint(equalTo: titleLabel.topAnchor, constant: -18).isActive = true
        trailingButtonView.trailingAnchor.constraint(equalTo: layerView.trailingAnchor, constant: -15).isActive = true
        trailingButtonView.heightAnchor.constraint(equalToConstant: 60).isActive = true
        widthAnchorConstraint = trailingButtonView.widthAnchor.constraint(equalToConstant: 165)
        widthAnchorConstraint.isActive = true
        
        trailingButtonView.addSubview(userCartButton)
        userCartButton.bottomAnchor.constraint(equalTo: trailingButtonView.bottomAnchor, constant: 0).isActive = true
        userCartButton.leadingAnchor.constraint(equalTo: trailingButtonView.leadingAnchor, constant: 0).isActive = true
        userCartButton.heightAnchor.constraint(equalToConstant: 45).isActive = true
        userCartButton.widthAnchor.constraint(equalToConstant: 45).isActive = true
        userCartButton.addTarget(self, action: #selector(showUserShoppingCart(_:)), for: .touchUpInside)
        
        trailingButtonView.addSubview(userOrdersButton)
        userOrdersButton.bottomAnchor.constraint(equalTo: trailingButtonView.bottomAnchor, constant: 0).isActive = true
        userOrdersButton.leadingAnchor.constraint(equalTo: userCartButton.trailingAnchor, constant: 15).isActive = true
        userOrdersButton.heightAnchor.constraint(equalToConstant: 45).isActive = true
        userOrdersButton.widthAnchor.constraint(equalToConstant: 45).isActive = true
        userOrdersButton.addTarget(self, action: #selector(showAllUserOrders), for: .touchUpInside)
        
        trailingButtonView.addSubview(userProfileButton)
        userProfileButton.bottomAnchor.constraint(equalTo: trailingButtonView.bottomAnchor, constant: 0).isActive = true
        userProfileButton.leadingAnchor.constraint(equalTo: userOrdersButton.trailingAnchor, constant: 15).isActive = true
        userProfileButton.heightAnchor.constraint(equalToConstant: 45).isActive = true
        userProfileButton.widthAnchor.constraint(equalToConstant: 45).isActive = true
        userProfileButton.addTarget(self, action: #selector(showSellerProfile), for: .touchUpInside)
        
        
        
        
        
        layerView.addSubview(searchField)
        searchField.semanticContentAttribute = AppManager.isLanguageEnglish ? .forceLeftToRight : .forceRightToLeft
        searchField.delegate = self
        searchField.bottomAnchor.constraint(equalTo: trailingButtonView.bottomAnchor, constant: 0).isActive = true
        searchField.leadingAnchor.constraint(equalTo: layerView.leadingAnchor, constant: 15).isActive = true
        searchField.trailingAnchor.constraint(equalTo: trailingButtonView.leadingAnchor, constant: -10).isActive = true
        searchField.heightAnchor.constraint(equalToConstant: 46).isActive = true
        searchField.setFieldImageIcon(imageName: "search-icon", imageInset: 2)
        searchField.setCustomPlaceHolder(AppStrings.Titles.search, fontSize: 16, textColor: .darkGray)
        
        searchField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
    
        setupNavigationBar()
        setupCategoryPicker()
        
        getRecommendedProductList()
        addUserCartUpdatesObserver()
        
        updateUserCartUI()
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        // to limit network activity, reload half a second after last key press.
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(searchProduct(_:)), object: nil)
        perform(#selector(self.searchProduct(_:)), with: textField, afterDelay: 1.0)
    }
    
    @objc func searchProduct(_ textField: UITextField) {
        if let text = searchField.text, text.trim().count > 0 {
            if let key = self.selectedCategory {
                if let item = self.categories?.firstIndex(where: {$0.categoryName == key}) {
                    self.categoryPickerView.itemCollectionView.deselectItem(at: IndexPath(item: item, section: 0), animated: true)
                }
            }
            self.refreshOnceOnly = true
            self.selectedCategory = "search"
            self.searchProductList(for: text, loaderEnabled: true)
        } else {
             self.refreshOnceOnly = true
            self.selectedCategory = nil
            self.getRecommendedProductList(loaderEnabled: true)
        }
        
    }
    
    private func searchProductList(for text: String?, loaderEnabled: Bool = true) {
        
        let parameters = ["search_string": text ?? ""]
        print(parameters)
        
        ApiClient.postRequestForJSON(serviceUrl: "item/search",
                                     serviceScheme: .serviceJSON,
                                     params: parameters,
                                     responseModel: ProductsDataModel.self,
                                     loaderEnabled: loaderEnabled) {(isSuccess, responseModel, message) in
                                        
                                        if isSuccess {
                                            let errorCode = responseModel?.errorCode
                                            
                                            switch errorCode {
                                                case 0:
                                                    let productsModelArr = responseModel?.data
                                                    self.reloadProducts(with: productsModelArr)
                                                
                                                default:
                                                    self.reloadProducts(with: nil)
                                            }
                                            
                                        } else {
                                            Alert.showAlert(self, message: message)
                                        }
                                        
        }
        
    }
    
    
  
    private func setupNavigationBar() {
        self.hidesBottomMenuBarWhenPushed = false
    }
    
    override func viewSafeAreaInsetsDidChange() {
        super.viewSafeAreaInsetsDidChange()
        listAttendanceView.contentInset = UIEdgeInsets(top: 215, left: 0, bottom: self.menuBarBottomInsets + 40, right: 0)
        layerView.updatePosition()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        layerView.updatePosition()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setupNavigationBar()

    }
    
    private func setupCategoryPicker() {
        categories = DataManager.shared.categories
        categoryPickerView.categories = categories
    }
    
    private func addUserCartUpdatesObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.handleUserCartUpdates(notification:)),
                                               name: .userShoppingCartUpdatedNotification, object: nil)
    }
    
    @objc func handleUserCartUpdates(notification: Notification) {
        self.updateUserCartUI(loaderEnabled: false)
    }
    
   
    
    
    
    private func downloadImage(with urlString: String) {
        if let image = UserCartManager.shared.sellerProfileImage {
            self.userProfileButton.setBackgroundImage(image, for: .normal)
            return
        }
        guard let url = URL(string: urlString) else {
            return
        }
        let resource = ImageResource(downloadURL: url)
        KingfisherManager.shared.retrieveImage(with: resource, options: nil, progressBlock: nil) { (image, err, type, url) in
            self.userProfileButton.setBackgroundImage(image, for: .normal)
            UserCartManager.shared.sellerProfileImage = image
        }
    }
    
    @objc private func showUserShoppingCart(_ sender: AnyObject) {
        self.view.endEditing(true)
        let viewController = CartViewController()
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    @objc private func showAllUserOrders() {
        let viewController = OrdersViewController()
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    @objc private func showSellerProfile() {
        let viewController = SellerProfileViewController()
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    
    private var hasRequiredReload = true
    private func updateUserCartUI(loaderEnabled: Bool = true) {
        
        if UserCartManager.shared.totalQuantity > 0 {
            
            if self.hasRequiredReload {
                self.hasRequiredReload = false
                if self.selectedCategory != nil {
                    let sellerID = UserCartManager.shared.sellerId
                    self.loadProductList(for: self.selectedCategory, sellerId: sellerID, loaderEnabled: loaderEnabled)
                } else {
                    self.getRecommendedProductList(loaderEnabled: loaderEnabled)
                }
                
                self.showUserCartOptions()
                
                if let userId = UserCartManager.shared.sellerId {
                    DataManager.getUserDetail(of: userId, loaderEnabled: false) { [unowned self](contact) in
                        if let imageUrl = contact?.dpimg {
                            self.downloadImage(with: imageUrl)
                        }
                    }
                }
            }
        
        } else {
            
            hasRequiredReload = true
            if self.selectedCategory != nil {
               loadProductList(for: self.selectedCategory, sellerId: "", loaderEnabled: loaderEnabled)
            } else {
                self.getRecommendedProductList(loaderEnabled: loaderEnabled)
            }
            
            self.showUserCartOptions()
            
        }
        
        userCartButton.badgeValue = UserCartManager.shared.totalQuantity
        
    }
    
    private func showUserCartOptions(isSearching: Bool = false) {
        
        if isSearching {
            if UserCartManager.shared.totalQuantity > 0 {
                widthAnchorConstraint.constant = 55
            } else {
                widthAnchorConstraint.constant = 45
            }
        } else {
            if UserCartManager.shared.totalQuantity > 0 {
                widthAnchorConstraint.constant = 165
            } else {
                widthAnchorConstraint.constant = 105
            }
        }
        
        UIView.animate(withDuration: 0.2,
                       delay: 0,
                       usingSpringWithDamping: 0.8,
                       initialSpringVelocity: 0.8,
                       options: .curveEaseInOut, animations: {
                        self.view.layoutIfNeeded()
        }, completion: nil)
        
    }
    
    
    
    var products = [ProductModel]()
    private var loadingFinished: Bool = false
    private func getRecommendedProductList(loaderEnabled: Bool = true) {
        
        let serviceUrl = "item/recomendedList"
        self.loadingFinished = false
        ApiClient.getRequestForJSON(serviceUrl: serviceUrl,
                                    serviceScheme: .serviceJSON,
                                    responseModel: ProductsDataModel.self,
                                    loaderEnabled: loaderEnabled) {(isSuccess, responseModel, message) in
                                        if isSuccess {
                                            let errorCode = responseModel?.errorCode
                                            
                                            switch errorCode {
                                                case 0:
                                                    
                                                    if let productsModelArr = responseModel?.data {
                                                        if let sellerID = UserCartManager.shared.sellerId {
                                                            let productsArr = productsModelArr.filter {$0.sellerId == sellerID}
                                                            self.reloadProducts(with: productsArr)
                                                        } else {
                                                            self.reloadProducts(with: productsModelArr)
                                                        }
                                                        
                                                    } else {
                                                        self.reloadProducts(with: nil)
                                                    }
                                                    
                                                    break
                                                
                                                default:
                                                    Alert.showAlert(self, message: AppStrings.Messages.unexpected_error)
                                            }
                                            
                                            
                                        } else {
                                            Alert.showAlert(self, message: message)
                                        }
        }
        
        
    }
    
    
    private func loadProductList(for category: String?, sellerId: String? = nil, loaderEnabled: Bool = true) {
       
        let parameters = ["category": category ?? "", "seller_id": sellerId ?? ""]
        print(parameters)
        
        ApiClient.postRequestForJSON(serviceUrl: "item/list",
                                     serviceScheme: .serviceJSON,
                                     params: parameters,
                                     responseModel: ProductsDataModel.self,
                                     loaderEnabled: loaderEnabled) {(isSuccess, responseModel, message) in
                                        
                                        if isSuccess {
                                            let errorCode = responseModel?.errorCode
                                            
                                            switch errorCode {
                                                case 0:
                                                    let productsModelArr = responseModel?.data
                                                    self.reloadProducts(with: productsModelArr)
                                                
                                                default:
                                                     self.reloadProducts(with: nil)
                                            }
                                            
                                        } else {
                                            Alert.showAlert(self, message: message)
                                        }
                                        
        }
        
    }
    
    
    private var refreshOnceOnly: Bool = true
    private var keys = [String]()
    private var keysAr = [String]()
    
    private func reloadProducts(with itemModels: [ProductModel]?) {
        self.products = itemModels ?? []
        let groupedProducts = Dictionary(grouping: self.products, by: {$0.category})
        self.keys = groupedProducts.keys.compactMap {$0}
        self.keys.sort(by: <) // ["A", "D", "Z"]
        let category = self.selectedCategory?.lowercased() ?? ""
        if category.elementsEqual("food") {
            self.keysAr.removeAll()
            self.keys.forEach { (key) in
                if let item = DataManager.shared.subCategories.first(where: {$0.categoryName == key}) {
                    self.keysAr.append(item.categoryNameAr ?? key)
                } else {
                    self.keysAr.append(key)
                }
            }
        }

        self.loadingFinished = true
        self.reloadProductsList()
    }
    
    
    private func reloadProductsList() {
        
        self.listAttendanceView.reloadData()
        self.listAttendanceView.setContentOffset(CGPoint(x: 0, y: -layerView.currentHeight), animated: false)
        
        if self.refreshOnceOnly {
            self.refreshOnceOnly = false
            
            let bottomAnimation = AnimationType.from(direction: .bottom, offset: 100.0)
            let anim1 = self.keys.count > 0 ? bottomAnimation : AnimationType.from(direction: .left, offset: 100.0)
            
            self.listAttendanceView.performBatchUpdates({
                
                let visibleCells = self.listAttendanceView.orderedVisibleCells
                
                UIView.animate(views: visibleCells,
                               animations: [anim1],
                               reversed: false,
                               initialAlpha: 0.0,
                               finalAlpha: 1.0,
                               delay: 0,
                               animationInterval: 0,
                               duration: 1.5,
                               usingSpringWithDamping: 0.6,
                               initialSpringVelocity: 1.0,
                               options: .curveEaseInOut,
                               completion: nil)
            }, completion: nil)
            
            
            
        } else {
            
            let leftAnimation = AnimationType.from(direction: .left, offset: 100.0)
            let bottomAnimation = AnimationType.from(direction: .bottom, offset: 100.0)
            
            let anim1 = self.keys.count > 0 ? bottomAnimation : AnimationType.from(direction: .left, offset: 100.0)
          
            
            self.listAttendanceView.performBatchUpdates({
                
                let visibleCells = self.listAttendanceView.orderedVisibleCells.split()
                
                UIView.animate(views: visibleCells.left,
                               animations: [anim1],
                               reversed: false,
                               initialAlpha: 0.0,
                               finalAlpha: 1.0,
                               delay: 0,
                               animationInterval: 0,
                               duration: 1.5,
                               usingSpringWithDamping: 0.6,
                               initialSpringVelocity: 1.0,
                               options: .curveEaseInOut,
                               completion: nil)
                
                UIView.animate(views: visibleCells.right,
                               animations: [leftAnimation],
                               reversed: false,
                               initialAlpha: 0.0,
                               finalAlpha: 1.0,
                               delay: 0,
                               animationInterval: 0,
                               duration: 1.5,
                               usingSpringWithDamping: 0.6,
                               initialSpringVelocity: 1.0,
                               options: .curveEaseInOut,
                               completion: nil)
                
            }, completion: nil)
        }
    }
    
    private func getAllProductsInSection(section: Int, for category: String?) -> [ProductModel]? {
        guard self.keys.count > 0 && category != nil else {
            return self.products
        }
        
        let categoryFilterKey = self.keys[section]
        let groupedProducts = Dictionary(grouping: self.products, by: {$0.category})
        return groupedProducts[categoryFilterKey]
    }
    
    private func numberOfSections(for category: String?) -> Int {
        guard self.products.count > 0 else { return 0 }
        guard let filterKey = category?.lowercased(), filterKey.elementsEqual("food") else {
            return 1
        }
        return self.keys.count
    }
    
    private func numberOfItemsInSection(section: Int, for category: String?) -> Int {
        guard self.keys.count > 0 && category != nil else {
            return self.products.count
        }
        return getAllProductsInSection(section: section, for: category)?.count ?? 0
    }
    
 
    private var isFilterActive: Bool = false
    private var isEmptyProductList: Bool {
        get {
            return self.products.first == nil && self.loadingFinished
        }
    }
    
    
    private func sendMessage(item: ProductModel) {
        let userId = item.sellerId
        DataManager.getUserDetail(of: userId, loaderEnabled: true) { [unowned self](contact) in
            if let contactModel = contact {
                self.showChatPage(for: userId, from: contactModel)
            } else {
                Alert.showAlert(self, message: AppStrings.Messages.unexpected_error)
            }
        }
    }
    
    private func showChatPage(for userId: String?, from contactModel: ContactModel) {
        if let selectedUserId = userId {
            if selectedUserId == contactModel.id {
                let vc = ChatDemoViewController()
                vc.contactModel = contactModel
                vc.selectedUserType = .seller
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
    
}


extension BuyerItemsViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        layerView.updatePosition()
        self.lastOffset = scrollView.contentOffset.y
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        if isEmptyProductList {
            return 1
        }
        return self.numberOfSections(for: self.selectedCategory)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if isEmptyProductList {
            return 1
        }
        return self.numberOfItemsInSection(section: section, for: self.selectedCategory)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
            
            case UICollectionView.elementKindSectionHeader:
                let headerView: BaseReusableView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, indexPath: indexPath)
                headerView.backgroundColor = .white
                headerView.addAction = { [unowned self] productItem in
                    self.didTappedItemAt(section: indexPath.section)
                }
                if self.selectedCategory == nil {
                    headerView.title = AppStrings.Titles.recommended
                } else if let category = self.selectedCategory?.lowercased(), category.elementsEqual("food") {
                    if self.keys.count > 0 {
                        headerView.title = AppManager.isLanguageEnglish ? self.keys[indexPath.section] : self.keysAr[indexPath.section]
                        if isFilterActive {
                            headerView.clockButton.imageView?.fadeTransition(0.2)
                            let img = UIImage(named: "arrow-icon")?.flip()
                            headerView.clockButton.setBackgroundImage(img, for: .normal)
                        } else {
                            headerView.clockButton.imageView?.fadeTransition(0.2)
                            let img = UIImage(named: "arrow-icon")
                            headerView.clockButton.setBackgroundImage(img, for: .normal)
                        }
                    }
                } else {
                    headerView.backgroundColor = .white
                    headerView.title = nil
                    headerView.clockButton.setBackgroundImage(nil, for: .normal)
                }
                return headerView
            
            case UICollectionView.elementKindSectionFooter:
                let headerView: BaseReusableFooterView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, indexPath: indexPath)
                headerView.backgroundColor = .white
                return headerView
            
            default:
                fatalError("Invalid View Type")
        }
    }
    
    
    
    private func didTappedItemAt(section: Int) {
        guard let category = self.selectedCategory?.lowercased(), category.elementsEqual("food") else {
            return
        }
        
        isFilterActive = !isFilterActive
        
        if isFilterActive {
            let selectedkey = self.keys[section]
            self.keys = [selectedkey]
            self.listAttendanceView.reloadData()
            let offset = listAttendanceView.contentOffset
            self.listAttendanceView.setContentOffset(CGPoint(x: offset.x, y: -220), animated: false)
        } else {
            let groupedProducts = Dictionary(grouping: self.products, by: {$0.category})
            let fromKey = self.keys.first
            self.keys = groupedProducts.keys.compactMap {$0}
            if let lastKey = fromKey, let index = self.keys.firstIndex(where: {$0 == lastKey}) {
                self.keys.remove(at: index)
                self.keys.insert(lastKey, at: 0)
            }
            self.listAttendanceView.reloadData()
        }
        
        let leftAnimation = AnimationType.from(direction: .left, offset: 100.0)
        let bottomAnimation = AnimationType.from(direction: .bottom, offset: 100.0)
        
        listAttendanceView.performBatchUpdates({
            let visibleCells = listAttendanceView.orderedVisibleCells.split()
            
            UIView.animate(views: visibleCells.left,
                           animations: [leftAnimation],
                           reversed: false,
                           initialAlpha: 0.0,
                           finalAlpha: 1.0,
                           delay: 0,
                           animationInterval: 0,
                           duration: 1.5,
                           usingSpringWithDamping: 0.6,
                           initialSpringVelocity: 1.0,
                           options: .curveEaseInOut,
                           completion: nil)
            
            
            UIView.animate(views: visibleCells.right,
                           animations: [bottomAnimation],
                           reversed: false,
                           initialAlpha: 0.0,
                           finalAlpha: 1.0,
                           delay: 0,
                           animationInterval: 0,
                           duration: 1.5,
                           usingSpringWithDamping: 0.6,
                           initialSpringVelocity: 1.0,
                           options: .curveEaseInOut,
                           completion: nil)
        }, completion: nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if isEmptyProductList {
            let cell: ErrorDataCell = collectionView.dequeueReusableCell(for: indexPath)
            cell.errorLabel.font = UIFont.defaultBold(size: 14)
            cell.errorMessage = AppStrings.Messages.no_items_found
            return cell
        } else {
            let cell: ProductCell = collectionView.dequeueReusableCell(for: indexPath)
            let products = getAllProductsInSection(section: indexPath.section, for: self.selectedCategory)
            cell.addAction = { [unowned self] productItem in
                self.addItemToShoppingCart(item: productItem)
            }
            cell.sendMessageAction = { [unowned self] productItem in
                self.sendMessage(item: productItem)
            }
            cell.product = products?[indexPath.item]
            return cell
        }
    }
    
    private func addItemToShoppingCart(item: ProductModel) {
        UserCartManager.shared.add(item)
        self.listAttendanceView.isUserInteractionEnabled = false
        if let itemNameEn = item.name?.capitalized, let itemNameAr = item.nameAr?.capitalized {
            let itemName = AppManager.isLanguageEnglish ? itemNameEn : itemNameAr
            Alert.showBanner(title: AppStrings.Titles.item_added,
                             message: "\u{200F}\(itemName) \(AppStrings.Titles.added_to_shopping_cart)",
            textColor: AppColor.primaryColor, backgroundColor: .black) { [unowned self] in
                self.updateUserCartUI()
                self.listAttendanceView.isUserInteractionEnabled = true
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let category = self.selectedCategory?.lowercased() ?? ""
        if category.trim().isEmpty || category.elementsEqual("food") {
            return CGSize(width: collectionView.frame.width, height: 40)
        }
        return CGSize(width: collectionView.frame.width, height: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 30)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if isEmptyProductList {
            return CGSize(width: collectionView.frame.width, height: 80)
        }
        return CGSize(width: (collectionView.frame.width - 20) / 2, height: 230)
    }
    
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        guard isEmptyProductList else {
            return true
        }
        return false
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let viewController = ProductDetailVC()
        let products = getAllProductsInSection(section: indexPath.section, for: self.selectedCategory)
        viewController.productModel = products?[indexPath.item]
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 5, left: 0, bottom: 0, right: 0)
    }
    
}

extension BuyerItemsViewController : CategoryPickerViewDelegate {
    
    func didSelectedCategoryAt(index: Int) {
        guard let category = self.categories?[index].categoryName else { return }
        self.selectedCategory = category
        isFilterActive = false
        if let sellerID = UserCartManager.shared.sellerId {
            self.loadProductList(for: self.selectedCategory, sellerId: sellerID)
        } else {
            self.loadProductList(for: self.selectedCategory)
        }
    }
    
    func didSelectedSubcategory(of name: String?) {
        self.selectedCategory = name
    }
    
}

extension BuyerItemsViewController: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.clearButtonMode = .whileEditing
        showUserCartOptions(isSearching: true)
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        textField.clearButtonMode = .never
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        showUserCartOptions(isSearching: false)
    }

}










