import ComposeApp
import SwiftUI
import UIKit

enum ReproFlow {
    case presentSheet
}

final class BaseHostingController<Content: View>: UIHostingController<AnyView> {
    init(rootView: Content) {
        super.init(rootView: AnyView(rootView))
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

@MainActor
final class ReproFlowController {
    let navigationController = UINavigationController()

    func start() -> UIViewController {
        let rootView = ReproRootView(
            onOpenSheet: { [weak self] in
                self?.handleFlow(.presentSheet)
            }
        )
        let rootViewController = BaseHostingController(rootView: rootView)
        navigationController.setViewControllers([rootViewController], animated: false)
        navigationController.navigationBar.isHidden = true
        return navigationController
    }

    func handleFlow(_ flow: ReproFlow) {
        switch flow {
        case .presentSheet:
            let rootView = ReproSheetView()
            let viewController = BaseHostingController(rootView: rootView)
            navigationController.present(viewController, animated: true)
        }
    }
}

struct FlowControllerContainerView: UIViewControllerRepresentable {
    func makeCoordinator() -> Coordinator {
        Coordinator()
    }

    func makeUIViewController(context: Context) -> UIViewController {
        let flowController = ReproFlowController()
        context.coordinator.flowController = flowController
        return flowController.start()
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}

    final class Coordinator {
        var flowController: ReproFlowController?
    }
}

struct ComposeViewController: UIViewControllerRepresentable {
    private let makeScreenViewController: () -> UIViewController

    init(makeScreenViewController: @escaping () -> UIViewController) {
        self.makeScreenViewController = makeScreenViewController
    }

    func makeUIViewController(context: Context) -> UIViewController {
        makeScreenViewController()
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}
}

struct ReproRootView: View {
    let onOpenSheet: () -> Void

    var body: some View {
        VStack {
            Button("Open repro sheet", action: onOpenSheet)
                .buttonStyle(.borderedProminent)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(uiColor: .systemBackground))
    }
}

struct ReproSheetView: View {
    var body: some View {
        ComposeViewController {
            ReproSheetViewControllerKt.ReproSheetViewController()
        }
        .ignoresSafeArea()
    }
}

struct ContentView: View {
    var body: some View {
        FlowControllerContainerView()
            .ignoresSafeArea()
    }
}
