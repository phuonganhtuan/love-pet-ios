//
//  PetModel.swift
//  Love Pets
//
//  Created by Phương Anh Tuấn on 30/03/2021.
//

import Foundation

struct PetModel: Decodable {
    
    var name: String? = ""
    var temperament: String? = ""
    var description: String? = ""
    var life_span: String? = ""
    var weight: WeightHeight? = WeightHeight()
    var image: PetImage? = PetImage()
}

struct WeightHeight: Decodable {
    var imperial: String? = ""
    var metric: String? = ""
}

struct PetImage: Decodable {
    var id: String? = ""
    var width: Int? = 0
    var height: Int? = 0
    var url: String? = ""
}
