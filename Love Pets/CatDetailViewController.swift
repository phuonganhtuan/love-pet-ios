//
//  CatDetailViewController.swift
//  Love Pets
//
//  Created by Phương Anh Tuấn on 30/03/2021.
//

import Foundation
import UIKit
import SDWebImage

class CatDetailViewController: UIViewController {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var textName: UILabel!
    @IBOutlet weak var textWeight: UILabel!
    @IBOutlet weak var textLifeSpan: UILabel!
    @IBOutlet weak var textDesc: UILabel!
    @IBOutlet weak var textTemperament: UILabel!
    @IBOutlet weak var imageCat: UIImageView!
    
    var cat: PetModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initViews()
        displayDetail()
    }
  
    private func initViews() {
        imageCat.layer.cornerRadius = 16
        imageCat.layer.shadowRadius = 16
    }
    
    private func displayDetail() {
        textName.text = cat?.name ?? ""
        textWeight.text = cat?.weight?.metric ?? "" + " kg"
        textLifeSpan.text = cat?.life_span ?? "" + " years"
        textTemperament.text = cat?.temperament
        textDesc.text = cat?.description ?? "No description."
        imageCat.sd_setImage(with: URL(string: cat?.image?.url ?? ""), placeholderImage: UIImage(named: "ImagePet.png"))
    }
}
