Map<String, String> generateMarketAnalysisTask(String targetObject) {
  return {
    'description': 'Analyze the current market trends and competitor rategies.',
    'expectedOutput': 'Comprehensive market analysis report',
    'prompt': '''Analyze the given product website: '$targetObject'.
			Extra details provided by the customer: '$targetObject'.

			Focus on identifying unique features, benefits,
			and the overall narrative presented.

			Your final report should clearly articulate the
			product's key selling points, its market appeal,
			and suggestions for enhancement or positioning.
			Emphasize the aspects that make the product stand out.

			Keep in mind, attention to detail is crucial for
			a comprehensive analysis. It's currenlty 2024.''',
  };
}

Map<String, String> generateStrategyDevelopmentTask() {
  return {
    'description': 'Develop a marketing strategy based on the market analysis.',
    'expectedOutput': 'Detailed marketing strategy document',
    'prompt': '''
     You're creating a targeted marketing campaign for: {product_website}.
			Extra details provided by the customer: {product_details}.

			To start this campaing we will need a strategy and creative content ideas.
			It should be meticulously designed to captivate and engage
			the product's target audience.

			Based on your ideas your co-workers will create the content for the campaign.

			Your final answer MUST be ideas that will resonate with the audience and
			also include ALL context you have about the product and the customer.
			"""),
'''
  };
}

Map<String, String> generateContentCreationTask(String targetObject) {
  return {
    'description': 'Create engaging content for various marketing channels.',
    'expectedOutput': 'Content pieces for different platforms',
    'prompt': '''
			The copy should be punchy, captivating, concise,
			and aligned with the product marketing strategy.

			Focus on creating a message that resonates with
			the target audience and highlights the product's
			unique selling points.

			Your ad copy must be attention-grabbing and should
			encourage viewers to take action, whether it's
			visiting the website, making a purchase, or learning
			more about the product.

			Your final answer MUST be 3 options for an ad copy for instagram that
			not only informs but also excites and persuades the audience.'''
  };
}

Map<String, String> generatePhotoShootingTask(String targetObject) {
  return {
    'description': 'Capture high-quality photos for marketing materials.',
    'expectedOutput': 'Set of professional photographs',
    'prompt': '''
      You are working on a new campaign for a super important customer,
			and you MUST take the most amazing photo ever for an instagram post
			regarding the product 

			This is the product you are working with: '$targetObject'.
			Extra details provided by the customer: '$targetObject'.

			Imagine what the photo you wanna take describe it in a paragraph.
			Here are some examples for you follow:
			- high tech airplaine in a beautiful blue sky in a beautiful sunset super cripsy beautiful 4k, professional wide shot
			- the last supper, with Jesus and his disciples, breaking bread, close shot, soft lighting, 4k, crisp
			- an bearded old man in the snows, using very warm clothing, with mountains full of snow behind him, soft lighting, 4k, crisp, close up to the camera

			Think creatively and focus on how the image can capture the audience's
			attention. Don't show the actual product on the photo.

			Your final answer must be 3 options of photographs, each with 1 paragraph
			describing the photograph exactly like the examples provided above.'''
  };
}

Map<String, String> generateCreativeDirectionTask(String targetObject) {
  return {
    'description':
        'Provide overall creative direction for the marketing campaign.',
    'expectedOutput': 'Creative brief and guidelines',
    'prompt': '''
  Review the photos you got from the senior photographer.
			Make sure it's the best possible and aligned with the product's goals,
			review, approve, ask clarifying question or delegate follow up work if
			necessary to make decisions. When delegating work send the full draft
			as part of the information.

			This is the product you are working with: '$targetObject'.
			Extra details provided by the customer: '$targetObject'.

			Here are some examples on how the final photographs should look like:
			- high tech airplaine in a beautiful blue sky in a beautiful sunset super cripsy beautiful 4k, professional wide shot
			- the last supper, with Jesus and his disciples, breaking bread, close shot, soft lighting, 4k, crisp
			- an bearded old man in the snows, using very warm clothing, with mountains full of snow behind him, soft lighting, 4k, crisp, close up to the camera

			Your final answer must be 3 reviewed options of photographs,
			each with 1 paragraph description following the examples provided above.'''
  };
}
