//
//  CertificatesView.swift
//  BrainRush
//
//  Certificates gallery view
//

import SwiftUI

struct CertificatesView: View {
    @StateObject private var certificateService = CertificateService.shared
    @State private var isLoading = false
    
    private var certificates: [Certificate] {
        certificateService.certificates
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                if isLoading {
                    ProgressView()
                        .frame(maxWidth: .infinity)
                        .padding()
                } else if certificates.isEmpty {
                    VStack(spacing: 16) {
                        Image(systemName: "doc.text.fill")
                            .font(.largeTitle)
                            .foregroundColor(.secondary)
                        Text("No certificates yet")
                            .foregroundColor(.secondary)
                        Text("Complete courses to earn certificates!")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                } else {
                    LazyVGrid(columns: [GridItem(.adaptive(minimum: 300))], spacing: 16) {
                        ForEach(certificates) { certificate in
                            NavigationLink(destination: CertificateDetailView(certificate: certificate)) {
                                CertificateCard(certificate: certificate)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                    .padding()
                }
            }
            .navigationTitle("Certificates")
            .task {
                await loadCertificates()
            }
        }
    }
    
    private func loadCertificates() async {
        isLoading = true
        await certificateService.loadCertificates()
        isLoading = false
    }
}

struct CertificateCard: View {
    let certificate: Certificate
    
    var body: some View {
        VStack(spacing: 12) {
            // Certificate preview
            RoundedRectangle(cornerRadius: 12)
                .fill(
                    LinearGradient(
                        colors: [Color.blue.opacity(0.3), Color.purple.opacity(0.3)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(height: 200)
                .overlay(
                    VStack {
                        Image(systemName: "seal.fill")
                            .font(.system(size: 60))
                            .foregroundColor(.white)
                        Text(certificate.title)
                            .font(.headline)
                            .foregroundColor(.white)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                    }
                )
            
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(certificate.type.capitalized)
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Text(formatDate(certificate.issuedAt))
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .foregroundColor(.secondary)
                    .font(.caption)
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
    }
    
    private func formatDate(_ dateString: String) -> String {
        return dateString
    }
}

struct CertificateDetailView: View {
    let certificate: Certificate
    @State private var showShareSheet = false
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Certificate Display
                VStack(spacing: 16) {
                    Image(systemName: "seal.fill")
                        .font(.system(size: 100))
                        .foregroundStyle(
                            LinearGradient(
                                colors: [.blue, .purple],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                    
                    Text(certificate.title)
                        .font(.title)
                        .fontWeight(.bold)
                        .multilineTextAlignment(.center)
                    
                    Text("Issued on \(formatDate(certificate.issuedAt))")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(
                    LinearGradient(
                        colors: [Color.blue.opacity(0.1), Color.purple.opacity(0.1)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .cornerRadius(16)
                .padding()
                
                // Actions
                VStack(spacing: 12) {
                    Button(action: downloadPDF) {
                        Label("Download PDF", systemImage: "arrow.down.circle.fill")
                            .frame(maxWidth: .infinity)
                            .frame(height: 50)
                    }
                    .buttonStyle(.borderedProminent)
                    
                    Button(action: { showShareSheet = true }) {
                        Label("Share", systemImage: "square.and.arrow.up")
                            .frame(maxWidth: .infinity)
                            .frame(height: 50)
                    }
                    .buttonStyle(.bordered)
                    
                    Button(action: openVerification) {
                        Label("Verify Certificate", systemImage: "checkmark.seal")
                            .frame(maxWidth: .infinity)
                            .frame(height: 50)
                    }
                    .buttonStyle(.bordered)
                }
                .padding()
            }
        }
        .navigationTitle("Certificate")
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $showShareSheet) {
            // Share sheet
        }
    }
    
    private func downloadPDF() {
        // Download PDF
    }
    
    private func openVerification() {
        // Open verification URL
    }
    
    private func formatDate(_ dateString: String) -> String {
        return dateString
    }
}

#Preview {
    CertificatesView()
}
