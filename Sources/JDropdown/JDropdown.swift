// The Swift Programming Language
// https://docs.swift.org/swift-book
import UIKit
import SnapKit

@available(iOS 13.0, *)
open class JDropdown: UIView,
                                UITableViewDataSource,
                                UITableViewDelegate {
    
    let dropdownButton = UIButton(type: .system)
    let tableView = UITableView()
    
    var data: [String]
    
    var isDropdownVisible = false {
        didSet {
            dropdownButton.setImage(isDropdownVisible ? UIImage(systemName: "chevron.up") : UIImage(systemName: "chevron.down"), for: .normal)
        }
    }
    
    public init(frame: CGRect, data: [String]) {
        self.data = data
        super.init(frame: frame)
        setupUI()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        self.data = []
        super.init(coder: aDecoder)
        setupUI()
    }
    
    func setupUI() {
        setupDropdownButton()
        setupTableView()
        
        self.tableView.isHidden = true
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier:"cell")
    }
    
    func setupDropdownButton() {
        addSubview(dropdownButton)
        
        dropdownButton.setTitle(data[0], for:.normal)
        dropdownButton.setTitleColor(.black, for:.normal)
        dropdownButton.setImage(UIImage(systemName: "chevron.up"),for:.normal)
        dropdownButton.tintColor = UIColor.black
        dropdownButton.titleLabel?.font = UIFont.systemFont(ofSize: 17.0, weight: .semibold)

        let spacing: CGFloat = 6
        dropdownButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: spacing - 10)
        dropdownButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: spacing + 10, bottom: 0, right: 0)


        dropdownButton.semanticContentAttribute = UIApplication.shared.userInterfaceLayoutDirection == .rightToLeft ? .forceLeftToRight : .forceRightToLeft
        
        dropdownButton.backgroundColor = .gray
        dropdownButton.layer.cornerRadius = 8.0
        
        dropdownButton.addTarget(self, action:#selector(toggleDropdown), for:.touchUpInside)
        
        dropdownButton.snp.makeConstraints {
            $0.top.centerX.equalToSuperview()
            $0.height.equalTo(50)
            $0.width.equalToSuperview()
         }
    }
    
    @objc func toggleDropdown() {
        
        if isDropdownVisible{
            UIView.animate(withDuration:0.3) {
                self.tableView.alpha = 0.0
            } completion: { _ in
                self.isDropdownVisible.toggle()
                self.tableView.isHidden = true
            }
        } else {
            tableView.alpha = 0.0
            tableView.isHidden = false
            
            UIView.animate(withDuration:0.3) {
                self.isDropdownVisible.toggle()
                self.tableView.alpha = 1.0
            }
        }
        
    }
    
    public func tableView(_ tableView:UITableView,numberOfRowsInSection section:Int)->Int{
        return data.count
    }
    
    public func tableView(_ tableView:UITableView,cellForRowAt indexPath : IndexPath)->UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")!
        
        cell.textLabel?.text = data[indexPath.row]
        cell.backgroundColor = .gray
        
        return cell
    }
    
    public func tableView(_ tableView:UITableView,didSelectRowAt indexPath : IndexPath){
        print("You selected \(data[indexPath.row])")
        dropDownButtonClick(title:data[indexPath.row])
        toggleDropdown()
    }
    
    func dropDownButtonClick(title:String){
        dropdownButton.setTitle(title,for:.normal)
        toggleDropdown()
    }
    
    func setupTableView(){
        
        tableView.separatorStyle = .none
        tableView.layer.cornerRadius = 8.0
        
        addSubview(tableView)
        
        tableView.snp.makeConstraints {
            $0.top.equalTo(dropdownButton.snp.bottom).offset(10)
            $0.left.right.bottom.equalToSuperview()
        }
    }
}
