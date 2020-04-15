//
//  GraphSoundTableCell.swift
//  MonicaPro
//
//  Created by Daniel Eriksson on 2018-08-14.
//  Copyright © 2018 CNet. All rights reserved.
//

import UIKit

class GraphSoundTableCell: UITableViewCell {

    @IBOutlet weak var labelDate: UILabel!
    @IBOutlet weak var labelMeterName: UILabel!
    @IBOutlet weak var viewBar: UIView!
    @IBOutlet weak var viewScatter: UIView!
    var dataCPBLZeq = NSMutableArray()
    var dataLAeqLCeq = NSMutableArray()

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.contentView.layoutSubviews()
        viewBar.subviews.forEach { $0.removeFromSuperview() }
        if dataCPBLZeq.count > 0 {
            let bcv = UIBarChartView(frame: viewBar.bounds, barPlotData: dataCPBLZeq, unitStr: "db")
            viewBar.addSubview(bcv!)
        }
        viewScatter.subviews.forEach { $0.removeFromSuperview() }
        if dataCPBLZeq.count > 0 {
            let plotView = UIScatterPlotView(frame: viewScatter.bounds)
            plotView.createChartIfNeeded()
            plotView.dataForPlot = dataLAeqLCeq
            plotView.backgroundColor = UIColor.white
            plotView.updatePlot()
            viewScatter.addSubview(plotView)
        }
    }
}
