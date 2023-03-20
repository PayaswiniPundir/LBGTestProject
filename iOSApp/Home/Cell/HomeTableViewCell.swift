import UIKit

class HomeTableViewCell: UITableViewCell {
    @IBOutlet private var userName: UILabel!
    @IBOutlet private var userEmail: UILabel!
    @IBOutlet private var userPhone: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }
    
    func setupView() {
        userName.font = Font.headline
        userEmail.font = Font.body
        userPhone.font = Font.body
        
    }
    
    func configure(_ userVM: UserModel) {
        self.userName.text = userVM.name
        self.userEmail.text = userVM.email
        self.userPhone.text = userVM.phone
   }
    
}
