//
//  BFRepositoryTypeFourCell.swift
//  BeeFun
//
//  Created by WengHengcong on 3/8/16.
//  Copyright © 2016 JungleSong. All rights reserved.
//

import UIKit

/// 用语Profile中我的项目

/// 有“语言”显示
class BFRepositoryTypeSecCell: BFBaseCell {

    @IBOutlet weak var nameLabel: UILabel!

    @IBOutlet weak var descLabel: UILabel!

    @IBOutlet weak var timeLabel: UILabel!

    @IBOutlet weak var starImgV: UIImageView!

    @IBOutlet weak var starNumLabel: UILabel!

    @IBOutlet weak var forkImgV: UIImageView!

    @IBOutlet weak var forkNumLabel: UILabel!

    @IBOutlet weak var langLabel: UILabel!

    var objRepos: ObjRepos? {

        didSet {

            nameLabel.text = objRepos!.name!
            descLabel.text = objRepos!.cdescription

            timeLabel.text = BFTimeHelper.shared.readableTime(rare: objRepos!.updated_at, prefix: nil)
            starNumLabel.text = "\(objRepos!.stargazers_count!)"
            forkNumLabel.text = "\(objRepos!.forks_count!)"
            if let lan = objRepos!.language {
                langLabel.text = "\(lan)"
            }
        }

    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        src_customView()
    }

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func src_customView() {

        nameLabel.textColor = UIColor.iOS11Black
        nameLabel.font = UIFont.largeSizeSystemFont()

        descLabel.textColor = UIColor.bfLabelSubtitleTextColor
        descLabel.font = UIFont.middleSizeSystemFont()

        timeLabel.textColor = UIColor.bfLabelSubtitleTextColor
        timeLabel.font = UIFont.smallSizeSystemFont()

        starNumLabel.textColor = UIColor.bfLabelSubtitleTextColor
        starNumLabel.font = UIFont.smallSizeSystemFont()

        forkNumLabel.textColor = UIColor.bfLabelSubtitleTextColor
        forkNumLabel.font = UIFont.smallSizeSystemFont()

        langLabel.textColor = UIColor.bfLabelSubtitleTextColor
        langLabel.font = UIFont.smallSizeSystemFont()

    }

}
