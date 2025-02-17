// import the Genkit and Google AI plugin libraries
import {gemini15Flash, googleAI} from '@genkit-ai/googleai';
import {genkit} from 'genkit';
import {defineSecret} from 'firebase-functions/params';
import {isSignedIn, onCallGenkit} from 'firebase-functions/https';

const googleAIapiKey = defineSecret('GOOGLE_GENAI_API_KEY');

// configure a Genkit instance
const ai = genkit({
  plugins: [googleAI()],
  model: gemini15Flash, // set default model
});

const helloGeminiFlow = ai.defineFlow({
    name: 'helloGeminiFlow',
    },

    async () => {
    // make a generation request
        return ai.generate('Hello, Gemini!');
    }
);

export const helloGeminiFunction = onCallGenkit({
    secrets: [googleAIapiKey],
        authPolicy: isSignedIn(),
    },
    helloGeminiFlow
);
