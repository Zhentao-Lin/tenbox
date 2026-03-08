import SwiftUI

struct ContentView: View {
    @EnvironmentObject var appState: AppState
    @State private var columnVisibility = NavigationSplitViewVisibility.all

    var body: some View {
        NavigationSplitView(columnVisibility: $columnVisibility) {
            VmListView()
                .toolbar(removing: .sidebarToggle)
        } detail: {
            if let vmId = appState.selectedVmId,
               let vm = appState.vms.first(where: { $0.id == vmId }) {
                VmDetailView(vm: vm, appState: appState)
            } else {
                Text("Select a VM")
                    .font(.title2)
                    .foregroundStyle(.secondary)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
        .navigationSplitViewStyle(.balanced)
        .onChange(of: columnVisibility) { _, newValue in
            if newValue != .all {
                columnVisibility = .all
            }
        }
        .toolbar {
            ToolbarItemGroup(placement: .primaryAction) {
                Button(action: { appState.showCreateVmDialog = true }) {
                    Label("New VM", systemImage: "plus.rectangle")
                }

                if let vmId = appState.selectedVmId,
                   let vm = appState.vms.first(where: { $0.id == vmId }) {
                    Button(action: { appState.showEditVmDialog = true }) {
                        Label("Edit", systemImage: "pencil")
                    }
                    .disabled(vm.state == .running)

                    Button(role: .destructive, action: {
                        appState.deleteVm(id: vmId)
                    }) {
                        Label("Delete", systemImage: "trash")
                    }
                    .disabled(vm.state == .running)

                    Divider()

                    if vm.state == .stopped || vm.state == .crashed {
                        Button(action: { appState.startVm(id: vmId) }) {
                            Label("Start", systemImage: "play.fill")
                        }
                    }

                    if vm.state == .running {
                        Button(action: { appState.stopVm(id: vmId) }) {
                            Label("Force Stop", systemImage: "stop.fill")
                        }

                        Button(action: { appState.rebootVm(id: vmId) }) {
                            Label("Reboot", systemImage: "arrow.clockwise")
                        }

                        Button(action: { appState.shutdownVm(id: vmId) }) {
                            Label("Shutdown", systemImage: "power")
                        }
                    }
                }
            }
        }
        .sheet(isPresented: $appState.showCreateVmDialog) {
            CreateVmDialog()
        }
        .sheet(isPresented: $appState.showEditVmDialog) {
            if let vmId = appState.selectedVmId,
               let vm = appState.vms.first(where: { $0.id == vmId }) {
                EditVmDialog(vm: vm)
            }
        }
    }
}
