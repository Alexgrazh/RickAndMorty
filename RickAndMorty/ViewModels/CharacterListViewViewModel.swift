//
//  CharacterListViewViewModel.swift
//  RickAndMorty
//
//  Created by Alex Grazhdan on 10.04.2023.
//

import UIKit

import UIKit

protocol RMCharacterListViewViewModelDelegate: AnyObject {
    func didLoadInitialCharacters()
    func didLoadMoreCharacters(with newIndexPaths: [IndexPath])

    func didSelectCharacter(_ character: ResultCharacter)
}

/// View Model to handle character list view logic
final class RMCharacterListViewViewModel: NSObject {

    public weak var delegate: RMCharacterListViewViewModelDelegate?

    private var isLoadingMoreCharacters = false

    private var characters: [ResultCharacter] = [] {
        didSet {
            for character in characters {
                let viewModel = RMCharacterCollectionViewCellViewModel(
                    characterName: character.name,
                    characterStatus: character.status,
                    characterImageUrl: URL(string: character.image)
                )
                if !cellViewModels.contains(viewModel) {
                    cellViewModels.append(viewModel)
                }
            }
        }
    }

    private var cellViewModels: [RMCharacterCollectionViewCellViewModel] = []

    private var apiInfo: RMGetAllCharactersResponse.Info? = nil

    /// Fetch initial set of characters (20)
    public func fetchCharacters() {
        RMServise.shared.execute(
            .listCharactersRequests,
            expecting: RMGetAllCharactersResponse.self
        ) { [weak self] result in
            switch result {
            case .success(let responseModel):
                let results = responseModel.results
                let info = responseModel.info
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

    /// Paginate if additional characters are needed
    public func fetchAdditionalCharacters(url: URL) {
        guard !isLoadingMoreCharacters else {
            return
        }
        isLoadingMoreCharacters = true
        guard let request = RMRequest(url: url) else {
            isLoadingMoreCharacters = false
            return
        }
        
        RMServise.shared.execute(request, expecting: RMGetAllCharactersResponse.self) { [weak self] result in
            guard let strongSelf = self else {
                return
            }
            switch result {
            case .success(let responseModel):
                let moreResults = responseModel.results
                let info = responseModel.info
                strongSelf.apiInfo = info

                let originalCount = strongSelf.characters.count
                let newCount = moreResults.count
                let total = originalCount+newCount
                let startingIndex = total - newCount
                let indexPathsToAdd: [IndexPath] = Array(startingIndex..<(startingIndex+newCount)).compactMap({
                    return IndexPath(row: $0, section: 0)
                })
                strongSelf.characters.append(contentsOf: moreResults)

                DispatchQueue.main.async {
                    strongSelf.delegate?.didLoadMoreCharacters(
                        with: indexPathsToAdd
                    )

                    strongSelf.isLoadingMoreCharacters = false
                }
            case .failure(let failure):
                print(String(describing: failure))
                self?.isLoadingMoreCharacters = false
            }
        }
    }

    public var shouldShowLoadMoreIndicator: Bool {
        return apiInfo?.next != nil
    }
}

// MARK: - CollectionView

extension RMCharacterListViewViewModel: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cellViewModels.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: RMCharacterCollectionViewCell.identifire,
            for: indexPath
        ) as? RMCharacterCollectionViewCell else {
            fatalError("Unsupported cell")
        }
        cell.configure(with: cellViewModels[indexPath.row])
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard kind == UICollectionView.elementKindSectionFooter,
              let footer = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: RMFooterLoadingCollectionReusableView.identefire,
                for: indexPath
              ) as? RMFooterLoadingCollectionReusableView else {
            fatalError("Unsupported")
        }
        footer.startAnimating()
        return footer
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        guard shouldShowLoadMoreIndicator else {
            return .zero
        }

        return CGSize(width: collectionView.frame.width,
                      height: 100)
    }

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

// MARK: - ScrollView
extension RMCharacterListViewViewModel: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard shouldShowLoadMoreIndicator,
              !isLoadingMoreCharacters,
              !cellViewModels.isEmpty,
              let nextUrlString = apiInfo?.next,
              let url = URL(string: nextUrlString) else {
            return
        }
        Timer.scheduledTimer(withTimeInterval: 0.2, repeats: false) { [weak self] t in
            let offset = scrollView.contentOffset.y
            let totalContentHeight = scrollView.contentSize.height
            let totalScrollViewFixedHeight = scrollView.frame.size.height

            if offset >= (totalContentHeight - totalScrollViewFixedHeight - 120) {
                self?.fetchAdditionalCharacters(url: url)
            }
            t.invalidate()
        }
    }
}


//protocol CharacterListViewViewModelDelegate: AnyObject {
//    func didLoadInitialCharacters()
//    func didLoadMoreCharacters(with newIndexPath: [IndexPath])
//    func didSelectCharacter(_ character: ResultCharacter)
//}
//
//final class CharacterListViewViewModel : NSObject {
//
//    public weak var delegate: CharacterListViewViewModelDelegate?
//    private var isLoadindgMoreChatarcters = false
//
//    private var characters : [ResultCharacter] = [] {
//        didSet {
//            for character in characters where !cellViewModal.contains(where: {$0.characterName == character.name}) {
//                let viewModal = RMCharacterCollectionViewCellViewModel(characterName: character.name,
//                                                                       characterStatus: character.status,
//                                                                       characterImageUrl: URL(string: character.image)
//                )
//                if !cellViewModal.contains(viewModal){
//                    cellViewModal.append(viewModal)
//                }
//
//            }
//        }
//
//    }
//
//    private var cellViewModal: [RMCharacterCollectionViewCellViewModel] = []
//
//    private var apiInfo: RMGetAllCharactersResponse.Info? = nil
//
//
//    public func fetchCharacters() {
//        RMServise.shared.execute(
//            .listCharactersRequests,
//            expecting: RMGetAllCharactersResponse.self
//        ) { [weak self] result in
//            switch result {
//            case .success(let responseModel):
//                print("1234\(responseModel)")
//                let results = responseModel.results
//
//                print("1234\(results)")
//                let info = responseModel.info
//                self?.characters = results
//                self?.apiInfo = info
//                DispatchQueue.main.async {
//                    self?.delegate?.didLoadInitialCharacters()
//                }
//            case .failure(let error):
//                print(String(describing: error))
//            }
//        }
//    }
//
//
//    public func fetchAdditionalCharacters(url: URL) {
//        guard !isLoadindgMoreChatarcters else {
//            return
//        }
//        isLoadindgMoreChatarcters = true
//        guard let request = RMRequest(url: url) else {
//            isLoadindgMoreChatarcters = false
//            return
//        }
//
//        RMServise.shared.execute(request, expecting: RMGetAllCharactersResponse.self) { [weak self] result in
//            guard let strongSelf = self else {
//                return
//            }
//            switch result {
//            case .success(let responseModel):
//                let moreResults = responseModel.results
//                let info = responseModel.info
//                strongSelf.apiInfo = info
//
//                let originalCount = strongSelf.characters.count
//                let newCount = moreResults.count
//                let total = originalCount+newCount
//                let startingIndex = total - newCount
//                let indexPathsToAdd: [IndexPath] = Array(startingIndex..<(startingIndex+newCount)).compactMap({
//                    return IndexPath(row: $0, section: 0)
//                })
//                strongSelf.characters.append(contentsOf: moreResults)
//
//                DispatchQueue.main.async {
//                    strongSelf.delegate?.didLoadMoreCharacters(
//                        with: indexPathsToAdd
//                    )
//
//                    strongSelf.isLoadindgMoreChatarcters = false
//                }
//            case .failure(let failure):
//                print(String(describing: failure))
//                self?.isLoadindgMoreChatarcters = false
//            }
//        }
//    }
//
//
//    public var sholdShowLoadMoreIndicator: Bool {
//        return apiInfo?.next != nil
//    }
//
//}
//
//extension CharacterListViewViewModel: UICollectionViewDataSource{
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return cellViewModal.count
//    }
//
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//      guard  let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RMCharacterCollectionViewCell.identifire, for: indexPath) as? RMCharacterCollectionViewCell else {
//            fatalError("Unsupporting")
//        }
//
//        cell.configure(with: cellViewModal[indexPath.row])
//        return cell
//    }
//
//    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
//        guard kind == UICollectionView.elementKindSectionFooter,
//        let footer = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: RMFooterLoadingCollectionReusableView.identefire, for: indexPath) as? RMFooterLoadingCollectionReusableView else {
//            fatalError("Unsupporting")
//        }
//        footer.startAnimeting()
//        return footer
//    }
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
//
//        guard sholdShowLoadMoreIndicator else {
//            return .zero
//        }
//        return CGSize(width: collectionView.frame.width, height: 100)
//    }
//
//}
//
//extension CharacterListViewViewModel: UICollectionViewDelegate , UICollectionViewDelegateFlowLayout{
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        let bounds = UIScreen.main.bounds
//        let width = (bounds.width - 30)/2
//        return CGSize(width: width, height: width * 1.5)
//    }
//
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        collectionView.deselectItem(at: indexPath, animated: true)
//        let character = characters[indexPath.row]
//        delegate?.didSelectCharacter(character)
//    }
//
//}
//
//extension CharacterListViewViewModel: UIScrollViewDelegate {
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        guard sholdShowLoadMoreIndicator,
//              !isLoadindgMoreChatarcters,
//              !cellViewModal.isEmpty,
//              let nextUrlString = apiInfo?.next,
//              let url = URL(string: nextUrlString) else {
//            return
//        }
//
//        Timer.scheduledTimer(withTimeInterval: 0.2, repeats: true) { [weak self] t in
//            let offset = scrollView.contentOffset.y
//            let totalContantHight = scrollView.contentSize.height
//            let totalScrollViewFixedHeight = scrollView.frame.size.height
//
//            if offset >= (totalContantHight - totalScrollViewFixedHeight - 120){
//                self?.fetchAdditionalCharacters(url: url)
//            }
//            t.invalidate()
//        }
//    }
//}
