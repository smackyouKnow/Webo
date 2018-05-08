//
//  StatusCell.swift
//  WeiBo
//
//  Created by godyu on 2018/5/2.
//  Copyright © 2018年 godyu. All rights reserved.
//

import UIKit
import SDWebImage
import CoreGraphics

@objc
protocol StatusCellDelegate : NSObjectProtocol {
    @objc func statusCellDidTapURLString(link : String, cell : StatusCell)
}

class StatusCell: UITableViewCell {

    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nickNameLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var sourceLabel: UILabel!
    @IBOutlet weak var titleLabel: CCYLabel!
    @IBOutlet weak var likeBtn: UIButton!
    @IBOutlet weak var dissBtn: UIButton!
    @IBOutlet weak var commentBtn: UIButton!
    @IBOutlet weak var shareBtn: UIButton!
    @IBOutlet weak var vipIcon: UIImageView!
    @IBOutlet weak var vipLevel: UIImageView!
    
    ///转发lebel
    @IBOutlet weak var replayLabel: CCYLabel?
    @IBOutlet weak var pictureView: StatusPicture!
    
    weak var delegate : StatusCellDelegate?
    
    
    var viewModel : WBStatusViewModel? {
        didSet {
            //身份文字
            self.vipIcon.image = viewModel?.vipIcon
            vipLevel.image = viewModel?.memberIcon
            
            //设置按钮
            self.commentBtn.setTitle(viewModel?.commentStr, for: .normal)
            self.shareBtn.setTitle(viewModel?.retWeetedStr, for: .normal)
            self.likeBtn.setTitle(viewModel?.likeStr, for: .normal)

            //标志文字
            nickNameLabel.text = viewModel?.status.user?.screen_name
            timeLabel.text = viewModel?.status.createDate?.ccy_dateDescription
            sourceLabel.text = viewModel?.status.source
            
            //详情文字
            self.replayLabel?.attributedText = viewModel?.relayAttribute
            titleLabel.attributedText = viewModel?.textAttributed
            //图片
            pictureView.statusViewModel = viewModel
            pictureView.urls = viewModel?.picURLs
            //头像
            profileImageView.sd_setImage(with: URL.init(string: (viewModel?.status.user?.profile_image_url)!)) { (image, error, none, url) in
                self.profileImageView.image = image?.circleImage()
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.replayLabel?.delegate = self
        self.titleLabel.delegate = self;
        
        self.layer.drawsAsynchronously = true
        
        self.layer.shouldRasterize = true
        
        self.layer.rasterizationScale = UIScreen.main.scale
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

//MARK: 图片的分类
extension UIImage {
    func circleImage() -> UIImage {
        
        UIGraphicsBeginImageContextWithOptions(self.size, false, 0.0);
        
        let ctx = UIGraphicsGetCurrentContext()
        
        //添加一个圆
        let rect = CGRect.init(x: 0, y: 0, width: self.size.width, height: self.size.height)
        ctx?.addEllipse(in: rect)
        
        ctx?.clip()
        
        self.draw(in: rect)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        return image!
    }
}

//MARK: label点击代理
extension StatusCell : CCYLabelDelegate {
    func labelDidSelectedLinkText(label: CCYLabel, link: String) {
        self.delegate?.statusCellDidTapURLString(link: link, cell: self)
    }
}
