//
//  CCYHomeViewController.swift
//  WeiBo
//
//  Created by godyu on 2018/4/27.
//  Copyright © 2018年 godyu. All rights reserved.
//

import UIKit
import MJRefresh


private let statusCellId = "statusCellId";
private let statusRetweetedCellId = "StatusRetweetedCell"
class CCYHomeViewController: BaseViewController {
    
    lazy var statusViewModel : CCYHomeStatusListViewModel = CCYHomeStatusListViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        FPSLabel.show()
        
        self.setupRefresh()
        // Do any additional setup after loading the view.
        
        NotificationCenter.default.addObserver(self, selector: #selector(cellPhotoClick), name: NSNotification.Name(rawValue: StatusCellBrowserPhotoNotification), object: nil)
    }
    
    ///点击图片通知
    @objc func cellPhotoClick(noti : NSNotification) {
        
        guard let userInfo = noti.userInfo as? [String : AnyObject],
            let selectedIndex = userInfo[WBStatusCellBrowserPhotoSelectedIndexKey] as? Int,
            let urls = userInfo[WBStatusCellBrowserPhotoUrlKey] as? [String],
            let imageViews = userInfo[WBStatusCellBrowserPhotosKey] as? [UIImageView]
        else {
            return
        }
        let vc = CCYPhotoBrowserController.photoBrowser(withSelectedIndex: selectedIndex, urls: urls, parentImageViews: imageViews)
        
        self.present(vc, animated: true, completion: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    override func setupTableView() {
        super.setupTableView()
        
        tableView?.separatorStyle = .none
        self.tableView?.rowHeight = 100
        self.tableView?.rowHeight = UITableViewAutomaticDimension
        
        
        self.tableView?.register(UINib.init(nibName: "StatusCell", bundle: nil), forCellReuseIdentifier: statusCellId)
        self.tableView?.register(UINib.init(nibName: "StatusRetweetedCell", bundle: nil), forCellReuseIdentifier: statusRetweetedCellId)
    }
    
}

extension CCYHomeViewController {

    private func setupRefresh() {
        
        self.tableView?.mj_header = MJRefreshNormalHeader.init(refreshingTarget: self, refreshingAction: #selector(loadNewData))
        self.tableView?.mj_footer = MJRefreshBackNormalFooter.init(refreshingTarget: self, refreshingAction: #selector(loadMoreData))
        self.tableView?.mj_header.isAutomaticallyChangeAlpha = true
        self.tableView?.mj_header.beginRefreshing()
    }
    
    @objc func loadNewData() {
        self.statusViewModel.loadStatus(pullup: false) { (isSuccess) in
            
            self.tableView?.reloadData()
            self.tableView?.mj_header.endRefreshing()
        }
    }
    @objc func loadMoreData() {
        self.statusViewModel.loadStatus(pullup: true) { (isSuccess) in
            self.tableView?.reloadData()
            self.tableView?.mj_footer.endRefreshing()
        }
        
    }
}

//MARK: tableView相关
extension CCYHomeViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.statusViewModel.statusList.count;
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let viewModel = self.statusViewModel.statusList[indexPath.row]
        let cellId = viewModel.status.retweeted_status == nil ? statusCellId : statusRetweetedCellId
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId) as! StatusCell
        
        cell.viewModel = viewModel
        cell.delegate = self
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let viewModel = self.statusViewModel.statusList[indexPath.row]
        return viewModel.rowHeight
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        print(scrollView.contentSize)
    }
}

//MARK: cell中富文本点击
extension CCYHomeViewController : StatusCellDelegate {
    func statusCellDidTapURLString(link: String, cell: StatusCell) {
        let vc = WebViewController()
        
        if link.hasPrefix("http") {
            vc.link = link
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
        
    }
}

