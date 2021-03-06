Class {
	#name : #PkcsEncryptedContentInfo,
	#superclass : #Object,
	#instVars : [
		'contentType',
		'contentEncryptionAlgorithm',
		'encryptedContent'
	],
	#category : 'PKCS12'
}

{ #category : #api }
PkcsEncryptedContentInfo >> cipherWithPassword: password [

	| salt iterations keyMaterial ivMaterial cipher |
	salt := self contentEncryptionAlgorithm parameters first.
	iterations := self contentEncryptionAlgorithm parameters last.

	self contentEncryptionAlgorithm oid oid = '1.2.840.113549.1.12.1.1'
		ifTrue: [
			keyMaterial := Pkcs12KeyDerivationFunction new
				derivedKeyWithId: 1 
				fromPassword: password
				salt: salt
				iterations: iterations
				size: 16.
			cipher := ARC4 new key: keyMaterial.
			^ cipher].
	self contentEncryptionAlgorithm oid oid = '1.2.840.113549.1.12.1.2'
		ifTrue: [
			keyMaterial := Pkcs12KeyDerivationFunction new
				derivedKeyWithId: 1 
				fromPassword: password
				salt: salt
				iterations: iterations
				size: 5.
			cipher := ARC4 new key: keyMaterial.
			^ cipher].
	self contentEncryptionAlgorithm oid oid = '1.2.840.113549.1.12.1.3'
		ifTrue: [
			keyMaterial := Pkcs12KeyDerivationFunction new
				derivedKeyWithId: 1 
				fromPassword: password
				salt: salt
				iterations: iterations
				size: 24.
			ivMaterial := Pkcs12KeyDerivationFunction new
				derivedKeyWithId: 2
				fromPassword: password
				salt: salt
				iterations: iterations
				size: 8.
			cipher := TripleDES new key: keyMaterial.
			cipher := cipher cbc initialVector: ivMaterial.
			^ cipher].
	self contentEncryptionAlgorithm oid oid = '1.2.840.113549.1.12.1.5'
		ifTrue: [
			keyMaterial := Pkcs12KeyDerivationFunction new
				derivedKeyWithId: 1 
				fromPassword: password
				salt: salt
				iterations: iterations
				size: 16.
			ivMaterial := Pkcs12KeyDerivationFunction new
				derivedKeyWithId: 2
				fromPassword: password
				salt: salt
				iterations: iterations
				size: 8.
			cipher := ARC2 key: keyMaterial effectiveKeyLength: 128.
			cipher := cipher cbc initialVector: ivMaterial.
			^ cipher].
	self contentEncryptionAlgorithm oid oid = '1.2.840.113549.1.12.1.6'
		ifTrue: [
			keyMaterial := Pkcs12KeyDerivationFunction new
				derivedKeyWithId: 1 
				fromPassword: password
				salt: salt
				iterations: iterations
				size: 5.
			ivMaterial := Pkcs12KeyDerivationFunction new
				derivedKeyWithId: 2
				fromPassword: password
				salt: salt
				iterations: iterations
				size: 8.
			cipher := ARC2 key: keyMaterial effectiveKeyLength: 40.
			cipher := cipher cbc initialVector: ivMaterial.
			^ cipher].
	^ nil
]

{ #category : #accessing }
PkcsEncryptedContentInfo >> contentEncryptionAlgorithm [
	"Answer the value of contentEncryptionAlgorithm"

	^ contentEncryptionAlgorithm
]

{ #category : #accessing }
PkcsEncryptedContentInfo >> contentEncryptionAlgorithm: anObject [
	"Set the value of contentEncryptionAlgorithm"

	contentEncryptionAlgorithm := anObject
]

{ #category : #accessing }
PkcsEncryptedContentInfo >> contentType [
	"Answer the value of contentType"

	^ contentType
]

{ #category : #accessing }
PkcsEncryptedContentInfo >> contentType: anObject [
	"Set the value of contentType"

	contentType := anObject
]

{ #category : #api }
PkcsEncryptedContentInfo >> decryptWithPassword: password [

	| cipher asn1 |
	cipher := self cipherWithPassword: password.
	asn1 := cipher decrypt: self encryptedContent.
	^ ASN1Stream 
		decodeBytes: asn1
		withType: ((ASN1Module name: #pkcs) find: #SafeContents).

]

{ #category : #accessing }
PkcsEncryptedContentInfo >> encryptedContent [
	"Answer the value of encryptedContent"

	^ encryptedContent
]

{ #category : #accessing }
PkcsEncryptedContentInfo >> encryptedContent: anObject [
	"Set the value of encryptedContent"

	encryptedContent := anObject
]
