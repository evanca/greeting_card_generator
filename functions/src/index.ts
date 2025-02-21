// import the Genkit and Google AI plugin libraries
import {gemini15Flash, googleAI} from '@genkit-ai/googleai';
import {genkit} from 'genkit';
import {defineSecret} from 'firebase-functions/params';
import {isSignedIn, onCallGenkit} from 'firebase-functions/https';
import {z} from 'genkit';
import {imagen3Fast, vertexAI} from '@genkit-ai/vertexai';

const googleAIapiKey = defineSecret('GOOGLE_GENAI_API_KEY');

// configure a Genkit instance
const ai = genkit({
  plugins: [googleAI(), vertexAI({location: 'us-central1'}),],
  model: gemini15Flash, // set default model
});

export const GreetingSchema = z.object({
    occasion: z.string(),
    recipientName: z.string(),
    age: z.number().nullable().optional(),
    additionalNotes: z.string().nullable().optional(),
    tone: z.number().default(0.5),
});

const generateGreetingTextFlow = ai.defineFlow(
    {
        name: 'generateGreetingTextFlow',
        inputSchema: GreetingSchema,
        outputSchema: z.string(),
    },
    async (input: z.infer<typeof GreetingSchema>): Promise<string> => {
        const generate = ai.prompt('greeting');
        return (await generate(input)).text;
    }
);

export const generateGreetingTextFunction = onCallGenkit({
        secrets: [googleAIapiKey],
        authPolicy: isSignedIn(),
    },
    generateGreetingTextFlow
);

const generateGreetingImageFlow = ai.defineFlow(
    {
        name: 'generateGreetingImageFlow',
        inputSchema: GreetingSchema,
    },
    async (input: z.infer<typeof GreetingSchema>): Promise<any> => {
        const generate = ai.prompt('image');
        const imagePrompt = (await generate(input)).text;

        console.log('imagePrompt', imagePrompt);

        const response = await ai.generate({
            model: imagen3Fast,
            prompt: imagePrompt,
            config: {
                temperature: 0.7,
            },
            output: {
                format: `media`,
            },
        });

        return response.media;
    }
);

export  const generateGreetingImageFunction = onCallGenkit({
        secrets: [googleAIapiKey],
        authPolicy: isSignedIn(),
    },
    generateGreetingImageFlow
);

