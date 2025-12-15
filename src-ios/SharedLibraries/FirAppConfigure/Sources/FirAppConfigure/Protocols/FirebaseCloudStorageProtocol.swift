//(c) Copyright PopAppFactory 2023

import FirebaseStorage

// NB: Intentionally omitted Sourcery annotations.
// TODO: Bring Firestore types under Swift protocols umbrella
public protocol FirebaseCloudStorageProtocol: AnyObject {
  func reference() -> StorageReference
}
