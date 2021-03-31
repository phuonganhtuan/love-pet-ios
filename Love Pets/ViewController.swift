//
//  ViewController.swift
//  Love Pets
//
//  Created by Phương Anh Tuấn on 30/03/2021.
//

import UIKit
import SDWebImage

class ViewController: UIViewController {

    @IBOutlet weak var progressBar: UIActivityIndicatorView!
    @IBOutlet weak var petCollectionView: UICollectionView!
    
    private let baseUrl = "https://api.thecatapi.com/v1/"
    private let apiKey = "38df5fbd-6e10-40f6-9db9-8332e4604849"
    
    private var catList: [PetModel] = []
    
    private let apiHelper = ApiHelper()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initViews()
        loadCatsFromServer()
    }
    
    private func initViews() {
        petCollectionView.delegate = self
        petCollectionView.dataSource = self
        petCollectionView.contentInset = UIEdgeInsets(top: 0, left: 6, bottom: 72, right: 6)
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.navigationItem.largeTitleDisplayMode = .automatic
    }
    
    private func loadCatsFromServer() {
        let catsPath = "breeds"
        let requestUrl = baseUrl + catsPath
        let params = ["key" : apiKey]
        apiHelper.sendRequest(requestUrl, parameters: params) { data, error in
            guard let responseData = data, error == nil else {
                print(error ?? "Unknown error")
                return
            }
            guard let cats = try? JSONDecoder().decode([PetModel].self, from: responseData) else {
                return
            }
            DispatchQueue.main.async {
                self.catList = cats
                self.petCollectionView.reloadData()
                self.progressBar.isHidden = true
            }
        }
    }
    
    private func openDetail(position: Int) {
        let detailVC = self.storyboard?.instantiateViewController(withIdentifier: "catDetailVC") as! CatDetailViewController
        detailVC.cat = catList[position]
        self.present(detailVC, animated: true, completion: nil)
//        self.navigationController?.pushViewController(detailVC, animated: true)
    }
}

extension ViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return catList.count
    }
        
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "petCell", for: indexPath) as! PetCell
        cell.imagePet.layer.cornerRadius = 12
        cell.imageDeep.layer.cornerRadius = 12
        cell.textName.text = catList[indexPath.row].name
        cell.imagePet.sd_setImage(with: URL(string: catList[indexPath.row].image?.url ?? ""), placeholderImage: UIImage(named: "ImagePet.png"))

        return cell
    }
}

extension ViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        openDetail(position: indexPath.row)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let screenSize = UIScreen.main.bounds
        let cellWidth = (screenSize.width / 2) - 18
        return CGSize(width: cellWidth, height: cellWidth * 4 / 5)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 12, left: 6, bottom: 0, right: 6)
    }
}
