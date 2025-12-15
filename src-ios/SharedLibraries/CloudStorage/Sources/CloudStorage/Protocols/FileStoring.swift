//(c) Copyright PopAppFactory 2023

/// sourcery: CreateMock
public protocol FileStoring {
  func file(path: String) -> FileStoring
}
