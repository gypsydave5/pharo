Extension { #name : #RBProgramNode }

{ #category : #'*OpalCompiler-Core' }
RBProgramNode >> asDoit [
	"The VM can only evaluate methods. wrap this ast in a doit MethodNode"
	| methodNode |
	
	methodNode := RBMethodNode 
		selector: #DoIt
		body: self asSequenceNode transformLastToReturn.
	methodNode source: methodNode formattedCode.
	^methodNode
	
]

{ #category : #'*OpalCompiler-Core' }
RBProgramNode >> asDoitForContext: aContext [
	"The VM can only evaluate methods. wrap this ast in a doitIn MethodNode to evaluate in a context"
	| methodNode |
	
	methodNode := RBMethodNode 
		selector: #DoItIn:
		arguments: { RBVariableNode named: 'ThisContext' } 
		body: self asSequenceNode transformLastToReturn.
	
	methodNode methodClass: aContext receiver class.
	methodNode rewriteTempsForContext: aContext.
	methodNode source: methodNode formattedCode.
	^methodNode
]

{ #category : #'*OpalCompiler-Core' }
RBProgramNode >> asSequenceNode [
	^RBSequenceNode statements: {self} 
]

{ #category : #'*OpalCompiler-Core' }
RBProgramNode >> doSemanticAnalysis [
	self methodNode ifNil: [ ^self ].
	^ self methodNode doSemanticAnalysis.
	
]

{ #category : #'*opalcompiler-core' }
RBProgramNode >> doSemanticAnalysisIn: aClass [
	self methodNode ifNil: [ ^self ].
	^ self methodNode doSemanticAnalysisIn: aClass
]

{ #category : #'*opalcompiler-core' }
RBProgramNode >> irInstruction [
	^ self methodOrBlockNode ir firstInstructionMatching: [:instr | instr sourceNode == self ]
]

{ #category : #'*opalcompiler-core' }
RBProgramNode >> isClean [
	^ self children allSatisfy: [ :child | child isClean ]
]

{ #category : #'*opalcompiler-core' }
RBProgramNode >> owningScope [

	^ parent owningScope 
]

{ #category : #'*opalcompiler-core' }
RBProgramNode >> scope [
	^ self methodOrBlockNode scope
]
