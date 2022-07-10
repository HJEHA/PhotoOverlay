//
//  PhotoResizeViewController.swift
//  PhotoOverlay
//
//  Created by 황제하 on 2022/07/09.
//

import UIKit

import RxSwift
import RxCocoa
import SnapKit

final class PhotoResizeViewController: UIViewController {

    // MARK: - Coordinator
    
    weak var coordinator: PhotoResizeCoordinator?
    
    // MARK: - Views
    
    private let photoResizeView = PhotoResizeView()
    
    private let saveButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .darkGray
        button.setTitle("   Save   ", for: .normal)
        button.layer.cornerRadius = 16
        
        return button
    }()
    
    // MARK: - Properties
    
    var viewModel: PhotoResizeViewModel?
    private var disposeBag = DisposeBag()
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureView()
        configureSubViews()
        configureBackButton()
        configureSaveButton()
        
        bindViewModel() 
    }
    
    deinit {
        coordinator?.popPhotoResizeView()
    }
}

// MARK: - Bind

extension PhotoResizeViewController {
    private func bindViewModel() {
        let input = PhotoResizeViewModel.Input(
            viewWillAppear: self.rx.viewWillAppear.asObservable(),
            resizeRate: photoResizeView.resizeSlider.rx.value.asObservable(),
            saveButtonTapEvent: saveButton.rx.tap.asObservable()
        )
        
        let output = viewModel?.transform(input)
        
        output?.imageObservable
            .observe(on: MainScheduler.asyncInstance)
            .withUnretained(self)
            .subscribe(onNext: { (owner, image) in
                owner.photoResizeView.update(image.image)
            })
            .disposed(by: disposeBag)
        
        output?.resizedTextObservable
            .bind(to: photoResizeView.resizedLabel.rx.text)
            .disposed(by: disposeBag)
        
        output?.savedOverlaidPhoto
            .observe(on: MainScheduler.asyncInstance)
            .flatMap { [weak self] _ in
                self?.showSaveSuccessAlert() ?? .empty()
            }
            .subscribe(onNext: { [weak self] _ in
                self?.coordinator?.showPhotoListView()
            })
            .disposed(by: disposeBag)
    }
}

// MARK: - Configure View

extension PhotoResizeViewController {
    private func configureView() {
        view.backgroundColor = .systemBackground
    }
    
    private func configureSubViews() {
        view.addSubview(photoResizeView)
        
        photoResizeView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            make.leading.trailing.equalToSuperview()
        }
    }
    
    func configureBackButton() {
        navigationController?.navigationBar.tintColor = .label
        navigationController?.navigationBar.topItem?.title = String()
    }
    
    func configureSaveButton() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: saveButton)
    }
}

// MARK: - Alert

extension PhotoResizeViewController {
    private func showSaveSuccessAlert() -> Observable<Void> {
        return Observable<Void>.create { [weak self] emitter in
            let alertController = UIAlertController(
                title: "저장이 완료되었습니다.",
                message: nil,
                preferredStyle: .actionSheet
            )
            
            let saveSussessAction = UIAlertAction(
                title: "확인",
                style: .default
            ) { _ in
                emitter.onNext(Void())
                emitter.onCompleted()
            }
            
            alertController.addAction(saveSussessAction)
                        
            self?.present(alertController, animated: true)
            
            return Disposables.create {
                alertController.dismiss(animated: true)
            }
        }
    }
}
