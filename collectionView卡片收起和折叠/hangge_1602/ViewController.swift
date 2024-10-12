//
//  ViewController.swift
//  hangge_1602
//
//  Created by hangge on 2017/3/15.
//  Copyright © 2017年 hangge. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    //普通的flow流式布局
    var flowLayout:UICollectionViewFlowLayout!
    //自定义的层叠布局
    var stackLayput:StackCollectionViewLayout!
    //自定义的层叠布局
    var testLayput:TestCollectionViewLayout!
    var collectionView:UICollectionView!
    var isExtent: Bool = false
    //重用的单元格的Identifier
    let CellIdentifier = "myCell"
    
    //所有书籍数据
    var images = ["c#.png", "html.png", "java.png", "js.png", "php.png"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //初始化Collection View
        initCollectionView()
        view.backgroundColor = UIColor.black
        //注册tap点击事件
//        let tapRecognizer = UITapGestureRecognizer(target: self,
//                                    action: #selector(ViewController.handleTap(_:)))
//        collectionView.addGestureRecognizer(tapRecognizer)
    }
    
    private func initCollectionView() {
        //初始化flow布局
        flowLayout = UICollectionViewFlowLayout()
        flowLayout.itemSize = CGSize(width: 373, height: 100)
        flowLayout.sectionInset = UIEdgeInsets(top: 12, left: 0, bottom: 0, right: 0)
        
        //初始化自定义布局
        stackLayput = StackCollectionViewLayout()
        
        testLayput = TestCollectionViewLayout()
        
        //初始化Collection View
        collectionView = UICollectionView(frame: CGRectMake(0, 120, self.view.bounds.width, self.view.bounds.height),
                                          collectionViewLayout: testLayput)
        
        //Collection View代理设置
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .black
        
        //注册重用的单元格
        let cellXIB = UINib.init(nibName: "MyCollectionViewCell", bundle: Bundle.main)
        collectionView.register(cellXIB, forCellWithReuseIdentifier: CellIdentifier)
        
        //将Collection View添加到主视图中
        view.addSubview(collectionView)
    }
    
    //点击手势响应
    @objc func handleTap(_ sender:UITapGestureRecognizer){
        if sender.state == UIGestureRecognizer.State.ended{
            let tapPoint = sender.location(in: self.collectionView)
            //点击的是单元格元素
            if let  indexPath = self.collectionView.indexPathForItem(at: tapPoint) {
                //通过performBatchUpdates对collectionView中的元素进行批量的插入，删除，移动等操作
                //同时该方法触发collectionView所对应的layout的对应的动画。
                self.collectionView.performBatchUpdates({ () -> Void in
                    self.collectionView.deleteItems(at: [indexPath])
                    self.images.remove(at: indexPath.row)
                }, completion: nil)
                
            }
            //点击的是空白位置
            else{
                //新元素插入的位置（开头）
                let index = 0
                images.insert("xcode.png", at: index)
                self.collectionView.insertItems(at: [IndexPath(item: index, section: 0)])
            }
        }
    }
    
    @IBAction func deleteAction(_ sender: UIBarButtonItem) {
        self.images.remove(at: 1)
        self.collectionView.deleteItems(at: [IndexPath(row: 1, section: 0)]);

        
    }
    //切换布局样式
    @IBAction func changeLayout(_ sender: Any) {
        self.collectionView.collectionViewLayout.invalidateLayout()
        //交替切换新布局
        let newLayout = collectionView.collectionViewLayout
            .isKind(of: TestCollectionViewLayout.self) ? flowLayout : testLayput
        isExtent = !isExtent
        if(isExtent)
        {
            self.collectionView.reloadData()
            // 使用 UIView.animate 来执行动画
            UIView.animate(withDuration: 0.3, animations: {
                self.collectionView.frame = CGRectMake(0, 120, self.view.bounds.width, 600);
                self.collectionView.backgroundColor = UIColor.gray;
            }) { (finished) in
                // 动画完成后的回调
                if finished {
                    print("动画完成")
                }
            }

            
        }else{
            // 定义新的框架

            // 使用 UIView.animate 来执行动画
            UIView.animate(withDuration: 0.3, animations: {
                // 动画持续时间设置为 0.3 秒
                self.collectionView.frame = CGRectMake(0, 120, self.view.bounds.width, 120);
                // 同时改变背景颜色
                self.collectionView.backgroundColor = UIColor.clear;
            }) { (finished) in
                // 动画完成后的回调
                if finished {
                    print("动画完成")
                }
            }
        }

//        collectionView.setCollectionViewLayout(newLayout!, animated: true)
        collectionView.setCollectionViewLayout(newLayout!, animated: true) {_ in 
            // 布局变化完成后刷新数据
            self.collectionView.reloadData()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

//Collection View数据源协议相关方法
extension ViewController: UICollectionViewDataSource {
    //获取分区数
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    //获取每个分区里单元格数量
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return self.images.count
    }
    
    //返回每个单元格视图
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        //获取重用的单元格
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier:
            CellIdentifier, for: indexPath) as! MyCollectionViewCell
        if(isExtent)
        {
            cell.contentView.backgroundColor = UIColor.white;

        }else{
            if(indexPath.row < 4)
            {
                cell.contentView.backgroundColor = UIColor.gray;

            }
        }
        
        //设置内部显示的图片
//        cell.imageView.image = UIImage(named: images[indexPath.item])
        cell.titlLabel.text = String(describing: indexPath.row);
        return cell
    }
}

//Collection View样式布局协议相关方法
extension ViewController: UICollectionViewDelegate {
    
}
