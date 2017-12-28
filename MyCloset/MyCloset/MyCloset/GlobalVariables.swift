//
//  GlobalVariables.swift
//  MyCloset
//
//  Created by Apple on 2017/11/27.
//  Copyright © 2017年 nju. All rights reserved.
//

import Foundation

    var closet: [[[Garment]]] = [] //存储衣服
    var curSelectedLargeClass = 0
    var curSelectedSubclass = 0
    public let largeclasses = ["上衣","下装","外套","连衣裙","鞋子","包","配饰"]
    public let subclasses = [["短袖", "T袖", "衬衫", "卫衣", "毛衣", "马甲", "其他上衣"],
                             ["牛仔裤","短裤","运动裤","七分裤","阔腿裤","半裙","长裙","其他下装"],
                             ["夹克", "风衣", "大衣", "羽绒服", "棉袄", "棒球服", "其他外套"],
                             ["短连衣裙", "长连衣裙", "其他连衣裙"],
                             ["运动鞋", "板鞋", "休闲鞋", "靴子", "凉鞋", "皮鞋", "其他鞋子"],
                             ["双肩包", "单肩包", "钱包", "旅行箱", "肩挎包", "其他包"],
                             ["帽子", "围巾", "腰带", "手套", "袜子", "头饰", "其他配饰"]]

    var dailyMatches: [String : Match] = [:]//每日搭配存储
    var favouriteMatches:[String: Match] = [:] //收藏搭配

