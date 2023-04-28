//
//  CharacterListViewViewModel.swift
//  RickAndMorty
//
//  Created by Alex Grazhdan on 10.04.2023.
//

import UIKit

protocol CharacterListViewViewModelDelegate: AnyObject {
    func didLoadInitialCharacters()
    func didSelectCharacter(_ character: ResultCharacter)
}

final class CharacterListViewViewModel : NSObject {
    
    public weak var delegate: CharacterListViewViewModelDelegate?
    private var isLoadindgMoreChatarcters = false
    
    private var characters : [ResultCharacter] = [] {
        didSet {
            for character in characters{
                let viewModal = RMCharacterCollectionViewCellViewModel(characterName: character.name,
                                                                       characterStatus: character.status,
                                                                       characterImageUrl: URL(string: character.image)
                )
                cellViewModal.append(viewModal)
            }
        }
      
    }
    
    private var cellViewModal: [RMCharacterCollectionViewCellViewModel] = []
    
    private var apiInfo : Info? = nil
    
    func fetchCharacters(){
        RMServise.shared.execute(.listCharactersRequests,
                                 expecting: RMCharacter.self) { [weak self]result in
            
            switch result {
            case .success(let responsemodel):
                let results = responsemodel.results
                let info = responsemodel.info
                self?.characters = results
                self?.apiInfo = info
                DispatchQueue.main.async {
                    self?.delegate?.didLoadInitialCharacters()
                }
            case .failure(let error):
                print(String(describing: error))
            }
        }
    }
    
    public func fetchAdditionalCharacters(){
        isLoadindgMoreChatarcters = true
    }
    
    public var sholdShowLoadMoreIndicator: Bool {
        return apiInfo?.next != nil
    }
    
}

extension CharacterListViewViewModel: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cellViewModal.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
      guard  let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RMCharacterCollectionViewCell.identifire, for: indexPath) as? RMCharacterCollectionViewCell else {
            fatalError("Unsupporting")
        }
    
        
        cell.configure(with: cellViewModal[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard kind == UICollectionView.elementKindSectionFooter,
        let footer = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: RMFooterLoadingCollectionReusableView.identefire, for: indexPath) as? RMFooterLoadingCollectionReusableView else {
            fatalError("Unsupporting")
        }
        footer.startAnimeting()
        return footer
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        
        guard sholdShowLoadMoreIndicator else {
            return .zero
        }
        return CGSize(width: collectionView.frame.width, height: 100)
    }
  
}

extension CharacterListViewViewModel: UICollectionViewDelegate , UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let bounds = UIScreen.main.bounds
        let width = (bounds.width - 30)/2
        return CGSize(width: width, height: width * 1.5)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let character = characters[indexPath.row]
        delegate?.didSelectCharacter(character)
    }
    
}

extension CharacterListViewViewModel: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard sholdShowLoadMoreIndicator else {
            return
        }
        
        let offset = scrollView.contentOffset.y
        let totalContantHight = scrollView.contentSize.height
        let totalScrollViewFixedHeight = scrollView.frame.size.height
        
        if offset >= (totalContantHight - totalScrollViewFixedHeight - 120){
            fetchAdditionalCharacters()
        }
    }
}
