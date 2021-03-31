//
//  DogViewController.swift
//  Love Pets
//
//  Created by Phương Anh Tuấn on 30/03/2021.
//

import Foundation
import UIKit

class DogViewController: UIViewController {
    
    @IBOutlet weak var progressBar: UIActivityIndicatorView!
    @IBOutlet weak var dogCollectionView: UICollectionView!
    
    private let baseUrl = "https://api.thedogapi.com/v1/"
    private let apiKey = "57ff224f-f8ce-4f31-b8ff-bda5058e3f17"
    
    private let apiHelper = ApiHelper()
    
    private var dogList: [PetModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initViews()
        loadDogsFromServer()
    }
    
    private func initViews() {
        dogCollectionView.delegate = self
        dogCollectionView.dataSource = self
        dogCollectionView.contentInset = UIEdgeInsets(top: 0, left: 6, bottom: 72, right: 6)
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.navigationItem.largeTitleDisplayMode = .automatic
    }
    
    private func loadDogsFromServer() {
        let dogsPath = "breeds"
        let requestUrl = baseUrl + dogsPath
        let params = ["key" : apiKey]
        apiHelper.sendRequest(requestUrl, parameters: params) { data, error in
            guard let responseData = data, error == nil else {
                print(error ?? "Unknown error")
                return
            }
            guard let dogs = try? JSONDecoder().decode([PetModel].self, from: responseData) else {
                return
            }
            DispatchQueue.main.async {
                self.dogList = dogs
                self.dogCollectionView.reloadData()
                self.progressBar.isHidden = true
            }
        }
    }
    
    private func openDetail(position: Int) {
        let detailVC = self.storyboard?.instantiateViewController(withIdentifier: "catDetailVC") as! CatDetailViewController
        detailVC.cat = dogList[position]
        self.present(detailVC, animated: true, completion: nil)
    }
}

extension DogViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dogList.count
    }
        
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "dogCell", for: indexPath) as! DogCell
        cell.imagePet.layer.cornerRadius = 12
        cell.imageDeep.layer.cornerRadius = 12
        cell.textName.text = dogList[indexPath.row].name
        cell.imagePet.sd_setImage(with: URL(string: dogList[indexPath.row].image?.url ?? ""), placeholderImage: UIImage(named: "ImageDog.png"))
        return cell
    }
}

extension DogViewController: UICollectionViewDelegateFlowLayout {
    
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
